extends Node3D

var movement_highlight = preload("res://scenes/movement_highlight.tscn")

@onready var camera: Camera3D = $"../Camera3D"
@onready var ray: RayCast3D = $RayCast3D
@onready var grid: GridMap = $"../GridMap"
@onready var party: Node3D = $"../Units/Party"
@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

@export var hover_tile: Vector3i
@export var selected_tile: Vector3i
# Insanely, it seems that gdscript does not have nullable primitive
# types. So we have an extra variable to make sure that hover_tile
# was actually set to something before we use it (it initializes to 0,0,0 which
# is a valid position)
@export var hover_set: bool = false
# There is almost certainly a better way to do this async
# highlight thing, but for now, we're going to use this 
# to keep track of whether we have activated the highlight
# on the currently hovered tile 
@export var selected_set: bool = false
# Should be this be managed somewhere else?
@export var movement_highlights: Dictionary[Vector3i, AnimatedSprite3D] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Show highlight sprite at selected or hovered tile
	if not selected_set and hover_set:
		sprite.visible = true
		# TODO: Remove magic number
		# (this is raising the sprite up .001 over the gridmap, as a grid mesh
		# is .25 thick)
		sprite.position = grid.map_to_local(hover_tile) + Vector3(0, .126, 0)
		sprite.rotation_degrees = Vector3(90, 0, 0)
	elif selected_set:
		sprite.visible = true
		sprite.position = grid.map_to_local(selected_tile) + Vector3(0, .126, 0)
		sprite.rotation_degrees = Vector3(90, 0, 0)
		
		# If a party unit has been selected, show their movement highlight
		if party.is_unit_selected() and movement_highlights.size() == 0:
			var selected_unit = party.selected_unit
			var pos = party.get_unit_grid_position(selected_unit)
			for new_pos in selected_unit.get_moveable_positions(pos):
				if grid.get_cell_item(new_pos) >= 0:
					var highlight: AnimatedSprite3D = movement_highlight.instantiate()
					highlight.position = grid.map_to_local(new_pos) + Vector3(0, .126, 0)
					highlight.rotation_degrees = Vector3(90, 0, 0)
					grid.add_child(highlight)
					movement_highlights[new_pos] = highlight

		# Everything I do feels hacky, but this is the best I can come up with
		# for now. This also is causing the frames to get out of sync,
		# but I'm not sure how to fix that yet.
		for k in movement_highlights.keys():
			if k != hover_tile:
				if movement_highlights[k].animation != "default":
					movement_highlights[k].play("default")
			else: 
				if movement_highlights[k].animation != "hover":
					movement_highlights[k].play("hover")
		
		
	else:
		sprite.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_hover_target(event.position)
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		# var double_click = event.double_click
		# var button_index = event.button_index
		if selected_set and hover_tile != selected_tile:
			selected_set = false
		elif hover_set:
			if party.select_unit_at_position_if_any(hover_tile):
				selected_set = true
				selected_tile = hover_tile
		else:
			selected_set = false

		if not selected_set:
			# Clear movement highlights
			for k in movement_highlights.keys():
				movement_highlights[k].queue_free()
			movement_highlights.clear()

func _hover_target(click_position: Vector2) -> void:
	var from = camera.project_ray_origin(click_position)
	var to = from + camera.project_ray_normal(click_position) * 1000
	var space_state = camera.get_world_3d().direct_space_state
	# TODO: Not 100% sure whether this is necessary
	ray.force_raycast_update()
	var ray_query_params = PhysicsRayQueryParameters3D.create(
		from, to
	)
	var selection = space_state.intersect_ray(ray_query_params)
	hover_set = false
	if "collider" in selection:
		if selection["collider"] == grid:
			# Subtract .01 from the Y position so that our result is just below the
			# surface of the gridmap we hit. If we hit the exact top, it's right
			# between two layers, so we get inconsistent results from local_to_map
			var pos = grid.local_to_map(selection.position - Vector3(0, .01, 0))
			var item = grid.get_cell_item(pos)
			# This is just a sanity check that the position we resolved to is acutally
			# one within the grid. This is likely only -1 in the case described below
			if item >= 0:
				hover_tile = pos
				hover_set = true
			else:
				# This is a weird case -- it means we hit the grid, but we're detecting
				# no item in the position that we hit. This is likely because we hit a 
				# wall and have the same problem as above:
				# That is, it's right between two layers, just
				# in the X or Z position instead. Decide what to do about this later. 
				# print("no item, probably hitting a wall or something else vertical")
				return

		else:
			for u in party.units:
				if selection["collider"] == u.get_body():
					var pos = party.get_unit_grid_position(u)
					hover_tile = pos
					hover_set = true
			return
	else:
		# No collision
		pass

extends Node3D

@onready var camera: Camera3D = $"../Camera3D"
@onready var ray: RayCast3D = $RayCast3D
@onready var grid: GridMap = $"../GridMap"

@export var hover_tile: Vector3i
@export var selected_tile: Vector3i
# Insanely, it seems that gdscript does not have nullable
# types. So we have an extra variable to make sure that hover_tile
# was actually set to something before we use it (it initializes to 0,0,0 which
# is a valid position)
@export var hover_set: bool = false
# There is almost certainly a better way to do this async
# highlight thing, but for now, we're going to use this 
# to keep track of whether we have activated the highlight
# on the currently hovered tile 
# (I think this might not be necessary once we are not
# changing the tile entirely in order to highlight it...
# I think a "shader" or spawning a little 2d image in the right
# spot would make more sense)
@export var last_processed_tile: Vector3i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hover_set and last_processed_tile != hover_tile:
		grid.set_cell_item(last_processed_tile, 1)
		grid.set_cell_item(hover_tile, 0)
		last_processed_tile = hover_tile

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_hover_target(event.position)
	if event is InputEventMouseButton:
		var double_click = event.double_click
		var button_index = event.button_index
		# todo: validate tile is selectable
		selected_tile = hover_tile

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
				pass
			else:
				# This is a weird case -- it means we hit the grid, but we're detecting
				# no item in the position that we hit. This is likely because we hit a 
				# wall and have the same problem as above:
				# That is, it's right between two layers, just
				# in the X or Z position instead. Decide what to do about this later. 
				print("no item, probably hitting a wall or something else vertical")
				return

		else:
			# Collided with something other than the grid map
			# TODO: What to do if we're hovering over a unit or something?
			pass
	else:
		# No collision
		pass

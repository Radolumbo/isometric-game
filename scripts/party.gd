extends Node3D

var unit = preload("res://scenes/unit.tscn")

@onready var grid: GridMap = $"../../GridMap"

@export var units: Array = []
# TODO: Remove this comment or move
# Not totally sure where to put this yet but this seems fine for now
@export var selected_unit: Unit = null

# Must be kept in sync. Don't love this, but it's terribly convenient.
var position_to_unit: Dictionary = {}
# Grid position is one til below where the unit is
var unit_name_to_grid_position: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_unit = unit.instantiate().with_data("Player")
	add_unit_to_grid(new_unit, Vector3i(2, 0, 2))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_unit_to_grid(new_unit: Unit, pos: Vector3i) -> void:
	# Add an instance of a unit
	add_child(new_unit)
	position_to_unit[pos] = new_unit
	unit_name_to_grid_position[new_unit.char_name] = pos
	new_unit.position = grid.map_to_local(pos + Vector3i(0, 1, 0))
	units.append(new_unit)

func remove_unit(dead_unit: Unit) -> void:
	var pos = unit_name_to_grid_position[dead_unit.char_name]
	position_to_unit.erase(pos)
	unit_name_to_grid_position.erase(dead_unit.char_name)
	units.erase(dead_unit)

	dead_unit.queue_free()

func get_unit_grid_position(target_unit: Unit) -> Vector3i:
	return unit_name_to_grid_position[target_unit.char_name]

func get_unit_at_grid_position_if_any(pos: Vector3i) -> Unit:
	if position_to_unit.has(pos):
		return position_to_unit[pos]

	return null

func select_unit_at_position_if_any(pos: Vector3i) -> bool:
	if position_to_unit.has(pos):
		selected_unit = position_to_unit[pos]
		print(selected_unit.char_name)
		return true

	return false

func is_unit_selected() -> bool:
	return selected_unit != null

func deselect_unit() -> void:
	selected_unit = null

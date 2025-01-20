extends Node3D

@onready var grid: GridMap = $"../../GridMap"

@export var units: Array = []

# Must be kept in sync. Don't love this, but it's terribly convenient.
var position_to_unit: Dictionary = {}
# Grid position is one til below where the unit is
var unit_name_to_grid_position: Dictionary = {}

var unit = preload("res://scenes/unit.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_unit = unit.instantiate().with_data("Player")
	add_unit_to_grid(new_unit, Vector3(2, 0, 2))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_unit_to_grid(new_unit: Node3D, pos: Vector3) -> void:
	# Add an instance of a unit
	add_child(new_unit)
	position_to_unit[pos] = new_unit
	unit_name_to_grid_position[new_unit.char_name] = pos
	new_unit.position = grid.map_to_local(pos + Vector3(0, 1, 0))
	units.append(new_unit)

func remove_unit(dead_unit: Node3D) -> void:
	var pos = unit_name_to_grid_position[dead_unit.char_name]
	position_to_unit.erase(pos)
	unit_name_to_grid_position.erase(dead_unit.char_name)
	units.erase(dead_unit)

	dead_unit.queue_free()

func get_unit_grid_position(target_unit: Node3D) -> Vector3:
	return unit_name_to_grid_position[target_unit.char_name]

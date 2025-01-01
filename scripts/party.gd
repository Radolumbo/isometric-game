extends Node3D

@onready var grid: GridMap = $"../../GridMap"

@export var units: Array = []

var unit = preload("res://scenes/unit.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_unit = unit.instantiate()
	add_unit(new_unit, Vector3(2, 1, 2))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_unit(new_unit: Node3D, position: Vector3) -> void:
	# Add an instance of a unit
	add_child(new_unit)
	new_unit.position = grid.map_to_local(position)
	units.append(unit)

func remove_unit(unit: Node3D) -> void:
	units.erase(unit)
	unit.queue_free()

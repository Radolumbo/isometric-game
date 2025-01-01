extends Node3D

@onready var dude: CharacterBody3D = $CharacterBody3D


@export var units: Array = [dude]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_unit(unit: CharacterBody3D) -> void:
	units.append(unit)

func remove_unit(unit: CharacterBody3D) -> void:
	units.erase(unit)

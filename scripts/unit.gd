extends Node3D
class_name Unit

@export var char_name = "Unit"
@export var movement_range = 4;
@onready var body: CharacterBody3D = $CharacterBody3D

# Cute way of instantiating with values
func with_data(new_name: String, new_movement_range: int = 4) -> Unit:
	self.char_name = new_name
	self.movement_range = new_movement_range
	return self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_moveable_positions(current_position: Vector3i) -> Array[Vector3i]:
	var moveable_positions: Array[Vector3i] = []
	for x in range(-movement_range, movement_range + 1):
		for z in range(-movement_range, movement_range + 1):
			var new_pos = current_position + Vector3i(x, 0, z)
			if new_pos != current_position and abs(x) + abs(z) <= movement_range:
				moveable_positions.append(new_pos)
			
	return moveable_positions

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_body() -> CharacterBody3D:
	return body

extends Node3D

@export var char_name = "Unit"
@onready var body: CharacterBody3D = $CharacterBody3D

# Cute way of instantiating with values
func with_data(new_name: String) -> Node3D:
	self.char_name = new_name
	return self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_body() -> CharacterBody3D:
	return body

extends AnimatedSprite2D

# Relative path is bad
@onready var tile_map_layers = $"../TileMapLayers"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func move():
	print(tile_map_layers.get_expected_z_index(self))

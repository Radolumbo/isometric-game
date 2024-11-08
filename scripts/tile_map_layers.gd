extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Note that this assumes that the `thing` is always on top of the highest
# tile at that position
# If we want to have "ceiling" and other high stuff obfuscate, maybe we could set
# a "highest possible Z" value or something 
func get_expected_z_index(thing: Node2D, thing_height: int = 32) -> int:
	# Base point should be center of character at the bottom
	var base_point: Vector2 = thing.position + Vector2(0, thing_height/2)
	# Figure out what the highest layer with something painted in is
	var layers = self.get_children();
	var z_index: int = 0
	var tile_coord = layers[0].local_to_map(base_point)
	for layer: TileMapLayer in layers:
		if layer.get_cell_tile_data(tile_coord) and layer.z_index > z_index:
			z_index = layer.z_index
		
	return z_index

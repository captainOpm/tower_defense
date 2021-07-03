extends TileMap


# Declare member variables here. Examples:
export var tile_groups = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_group(pos):
	var coords = get_cell_autotile_coord(pos.x, pos.y)
	for key in tile_groups:
		for v in tile_groups[key]:
			if v == coords:
				return key

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

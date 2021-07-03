extends Node2D

var rects = []
var current
var world

func _ready():
	get_node("/root/Main").connect("scene_change", self, "_on_scene_change")
	
func _on_scene_change(scene):
	world = scene
	world.connect("on_change", self, "on_change")

func cycle():
	if !world: return
	var keys = world.dijkstra.keys()
	if !keys.size():
		visible = false
		return
	var index = -1
	if current: index = keys.find(current)
	index += 1
	if index >= keys.size():
		current = null
		visible = false
		return
	visible = true
	current = keys[index]
	dijkstra(world.dijkstra[current], world.get_node("TileMap").cell_size)
	
func on_change():
	if current && world.dijkstra.has(current):
		dijkstra(world.dijkstra[current], world.get_node("TileMap").cell_size)

func dijkstra(map, tile_size):
	rects.clear()
	for x in range(map.score.size()):
		for y in range(map.score[x].size()):
			if map.score[x][y] == null: continue
			rects.append({"rect": Rect2(x * tile_size.x, y * tile_size.y, tile_size.x, tile_size.y), "color": Color.from_hsv((map.score[x][y] / map.max_cost) * 0.66, 1, 1, 0.5)})
	update()

func _draw():
	for rect in rects:
		draw_rect(rect.rect, rect.color)

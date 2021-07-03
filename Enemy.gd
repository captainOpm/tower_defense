extends Area2D
class_name Enemy

export (float) var speed = 1
export (float) var hitpoints = 20
export (String) var dijkstra
export (int) var reward = 30
var destination
var world
export (bool) var everhealed = false

func _process(delta):
	if !dijkstra:
		print_debug("no dijkstra map assigned!")
		return
	z_index = position.y
	if get_node("/root/Main").state != "playing": return
	# Récupération de la position du spawner
	var spawnPos = world.spawners[0].position
	# On détermine si notre ennemie est sur la position du spawner 
	# Moyenant un écart acceptable (sinon retourne toujours false
	var isOnSpawn = (position.x < spawnPos.x + 5 && position.x > spawnPos.x - 5) && (position.y < spawnPos.y + 5 && position.y > spawnPos.y - 5)
	if world.dijkstra.has(dijkstra) && (!name.match('*Tank*') || !isOnSpawn || hitpoints >= 50):
		var distance = 0
		if destination:
			distance = position.distance_to(destination)
		var tile_map = world.tile_map
		var tile_pos = tile_map.world_to_map(position)
		var move_amount = delta * speed / world.get_cost(tile_pos)
		if (distance < move_amount):
			destination = tile_map.map_to_world(world.dijkstra[dijkstra].get_next(tile_pos))
		position = position.move_toward(destination, move_amount)
	else:
		# Si on est un tank au spawn avec peu de vie on se heal
		everhealed = true
		hitpoints += .1

func take_damage(amount):
	hitpoints -= amount
	if (name.match('*Tank*') && hitpoints <= 50 && !everhealed):
		# Ici on définit que quand le tank passe sous le seuil des 50hp
		# Il retourne en direction de la base
		destination = world.spawners[0].position
	if (hitpoints <= 0):
		queue_free()
		var main = get_node("/root/Main")
		# on donne la récompense au joueur pour avoir tué un ennemi
		main.money += reward
		
func _exit_tree():
	world.remove_enemy(self)
	if (name.match('*Tank*')):
		# Ici on définit que quand le tank arrive a court de pv
		# En plus d'être détruit comme tout les items de classe ennemy
		# Il invoque également un ArmoredCar sur ca position
		var area2d = load("res://entities/Enemies/ArmoredCar.tscn")
		var oldEnemy = self
		var newEnemy = area2d.instance()
		newEnemy.position = Vector2(oldEnemy.position.x,oldEnemy.position.y)
		world.add_enemy(newEnemy)

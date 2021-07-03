extends Reference
class_name DijkstraMap

# les positions relatives à la case actuelle qu'on va explorer. On pourrait ajouter les diagonales ici.
const neighbours = [Vector2(1, 0), Vector2(0, 1), Vector2(0, -1), Vector2(-1, 0)]

# les prochaines positions qu'on doit parcourir.
# le système de priorité permet de les trier selon le coût.
var frontier = PriorityQueue.new()
var score = []
var max_cost = 0
var destinations
var cost

func _init(destinations, cost):
	self.destinations = destinations
	self.cost = cost

# traiter une position voisine
func _handle_neighbour(current, neighbour, cost):
	# vérifier si la position retnre dans les limites de la grille des coûts
	if neighbour.x < 0 || neighbour.x >= cost.size() || neighbour.y < 0 || neighbour.y >= cost[neighbour.x].size(): return
	# un coût nul signifie qu'on ne peut pas traverser cette case
	if cost[neighbour.x][neighbour.y] == null: return
	# on calcule le coût total ici, c'est à dire le coût cumulé de la case actuelle et des cases pour y arriver
	# plus le coût de la nouvelle case
	var new_cost = score[current.x][current.y] + cost[neighbour.x][neighbour.y]
	# un score nul veut dire qu'on ne l'a pas encore calculé
	# sinon, si le nouveau score est plus bas (donc coûte moins cher), on veut remplacer celui qu'on avait précédemment
	if score[neighbour.x][neighbour.y] == null || new_cost < score[neighbour.x][neighbour.y]:
		# mettre à jour le score
		score[neighbour.x][neighbour.y] = new_cost
		# on va mettre la case dans la liste pour pouvoir analyser ses voisines
		frontier.insert(neighbour, new_cost)
		# pour le moment le coût max ne sert que pour la visualisation debug et n'a pas besoin d'être exact
		# il pourrait arriver que cette valeur soit plus élevée que le vrai score maximal
		max_cost = max(max_cost, new_cost)

# calculer la grille des scores		
func calculate():
	frontier.clear()
	max_cost = 0
	# réinitialiser la grille des scores et suivre les dimensions de la grille des coûts
	score.clear()
	for x in range(cost.size()):
		score.append([])
		score[x].resize(cost[x].size())
		
	# chaque objectif a un score de 0 et on l'insère dans la liste des positions à traiter
	for pos in destinations:
		score[pos.x][pos.y] = 0
		frontier.insert(pos, 0)

	# tant qu'il reste des cases à traiter...
	while !(frontier.empty()):
		var current = frontier.get_next()
		# on traiter chaque case voisine de la case actuelle
		for neighbour in neighbours:
			# cette fonction va insérer d'autres positions dans la liste si besoin
			_handle_neighbour(current, current + neighbour, cost)
			
	# comme les destinations sont souvent des bâtiments, on vérifie après avoir calculé les scores si on peut traverser ces cases ou pas
	for pos in destinations:
		if cost[pos.x][pos.y] == null: score[pos.x][pos.y] = null
	
# trouver la prochaine case par rapport à une position
func get_next(pos):
	# si on ne trouve aucun résultat, on va rester dans la même case
	var lowest_neighbour = Vector2(pos.x, pos.y)
	var lowest_score = score[lowest_neighbour.x][lowest_neighbour.y]
	# on veut celle avec le score le plus bas
	for neighbour in neighbours:
		var neighbour_pos = pos + neighbour
		if neighbour_pos.x < 0 || neighbour_pos.x >= score.size() || neighbour_pos.y < 0 || neighbour_pos.y >= score[neighbour_pos.x].size(): continue
		var neighbour_score = score[neighbour_pos.x][neighbour_pos.y]
		if neighbour_score != null && neighbour_score < lowest_score:
			lowest_score = neighbour_score
			lowest_neighbour = pos + neighbour
	return lowest_neighbour
	
	

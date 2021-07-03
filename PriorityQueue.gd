# une implémentation simple d'une "priority queue", c'est à dire une liste où les éléments sont triés par priorité.

extends Reference
class_name PriorityQueue

var values = []

func compare(a, b):
	return a.priority < b.priority
		
# insérer un élément selon sa priorité. Une priorité plus basse indique un élément plus important.
func insert(value, priority):
	var obj = {"value": value, "priority": priority}
	# bsearch_custom permet de trouver l'index d'insertion en respectant l'ordre défini par la fonction "compare"
	var index = values.bsearch_custom(obj, self, "compare")
	values.insert(index, obj)

# enlever et retourner l'élément du devant de la queue.	
func get_next():
	return values.pop_front().value
	
# réinitialiser la liste
func clear():
	values.clear()
	
# permet de savoir s'il reste des éléments
func empty():
	return !values.size()

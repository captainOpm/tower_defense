extends Panel



# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/Main").connect("money_change", self, "_on_money")

func _on_money(amount):
	get_node("Label").text = String(amount)

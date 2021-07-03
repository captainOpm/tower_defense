extends CanvasLayer

var defeat
var victory

func _ready():
	defeat = get_node("Defeat")
	victory = get_node("Victory")
	get_node("/root/Main").connect("state_change", self, "_on_state_change")

func _on_state_change(state):
	defeat.visible = false
	victory.visible = false
	if state == "defeated":
		defeat.visible = true
	if state == "victorious":
		victory.visible = true
		
func on_restart():
	var main = get_node("/root/Main")
	main.state = "playing"
	main.set_map(main.current_map)


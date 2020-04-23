extends Area2D

var balance = 0

func _ready():
	pass

# returns "register"
func get_tag():
	return "register"

# updates health, money and score based on the enemys condition
func _on_Area2D_area_entered(area):
	if area.get_tag() == "enemy":
		var rn = get_node("/root/Game")
		if area.hungry():
			rn._update_health()
		else:
			rn._update_score()
			rn.update_money(area.bill)
		area.queue_free()

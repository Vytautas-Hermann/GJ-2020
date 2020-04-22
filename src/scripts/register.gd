extends Area2D

var balance = 0

func _ready():
	pass

func get_tag():
	return "register"

func _on_Area2D_area_entered(area):
	if area.get_tag() == "enemy":
		var rn = get_node("/root/Game")
		if area.hungry():
			rn._update_health(-1)
			#$Sound.play();
		else:
			rn._update_score(1)
			rn._update_money(area.bill)
		area.queue_free()

extends Area2D
var balance = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_tag():
	return "register"


func _on_Area2D_area_entered(area):
	if area.get_tag() == "enemy":
		var cl = get_node("/root/Game/Camera2D/CanvasLayer")
		if area.hungry():
			cl._decrease_health(1)
			$Sound.play();
		else:
			cl._increase_score(1)
			cl._change_money(area.bill)
		area.queue_free()

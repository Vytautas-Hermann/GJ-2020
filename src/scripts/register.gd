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
		if not area.hungry():
			balance += area.get_bill()
			print(balance)

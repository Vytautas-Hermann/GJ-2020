extends Area2D

export (PackedScene) var Munition
var firespeed = 2000

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$FireTimer.start()

func _on_FireTimer_timeout():
	var bullet = Munition.instance()
	add_child(bullet)
	var direction = deg2rad(0)
	bullet.position = get_node(".").position
	bullet.scale = Vector2(0.1,0.1)
	bullet.linear_velocity = Vector2(float(firespeed * bullet.aerodynamical_slowfactor), 0).rotated(direction)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

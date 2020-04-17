extends RigidBody2D


export var speed = 10
var type = "Prof"
var allergies = ["lactose", "gluten"]
var saturation = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print(allergies)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends RigidBody2D


export var speed = 100
var type = "Prof"
var allergies = ["lactose", "gluten"]
var saturation = 0
var hunger = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	hunger = rand_range(20,200)


func _on_Enemy_body_entered(_body):
	print("collision")
	saturation += _body.nutritional_value
	print(saturation)
	for substance in _body.substances:
		if substance in allergies:
			_body.queue_free()
			queue_free()
	_body.queue_free()
	




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends RigidBody2D

var nutrition_value = 100
var aerodynamical_slowfactor = 0.5
var substances = ["lactose"]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	aerodynamical_slowfactor = rand_range(0.5, 0.9)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

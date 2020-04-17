extends Area2D

var nutrition_value = 100
var aerodynamical_slowfactor = 0.5
var substances = ["lactose"]
var direction
var speed 
var screen_size

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	aerodynamical_slowfactor = rand_range(0.5, 0.9)
	screen_size = get_viewport_rect().size
	direction = Vector2(-1,0)

func _process(delta):
	position += direction * speed * delta * aerodynamical_slowfactor


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

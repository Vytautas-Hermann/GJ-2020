extends Area2D

var nutrition_value = 100
var aerodynamical_slowfactor = 0.5
var substances = ["lactose"]
var direction
var speed 
var screen_size


func _ready():
	aerodynamical_slowfactor = rand_range(0.5, 0.9)
	screen_size = get_viewport_rect().size
	direction = Vector2(-1,0)

func get_type():
	return "bullet"

func get_nv():
	return nutrition_value

func _process(delta):
	position += direction * speed * delta * aerodynamical_slowfactor


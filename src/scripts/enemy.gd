extends Area2D


var speed
var type = "Prof"
var allergies = ["lactose", "gluten"]
var saturation = 0
var hunger
var v
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = rand_range(100,200)
	screen_size = get_viewport_rect().size
	hunger = rand_range(20,200)
	var f = rand_range(0,1)
	v = Vector2(f*speed, (1-f)*speed)

func _process(delta):
	position += v * delta


func _on_Enemy_area_entered(area):
	print(area.get_name())
	#saturation += area.nutritional_value
	#print(saturation)
	#for substance in area.substances:
	#	if substance in allergies:
	#		area.queue_free()
	#		queue_free()
	#area.queue_free()
	




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

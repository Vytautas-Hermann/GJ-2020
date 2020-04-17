extends Area2D
#allergies and their probabilities
var available_allergies = {
	"gluten": 0.05, 
	"lactose": 0.1, 
	"diabetis": 0.005, 
	"fish": 0.125
	}
var speed
var type
var allergies = []
var saturation = 0
var hunger
var v
var screen_size

func set_type(t):
	type = t

# Called when the node enters the scene tree for the first time.
func _ready():
	for allergy in available_allergies:
		if rand_range(0,1) < available_allergies[allergy]:
			allergies.append(allergy)
	speed = rand_range(100,200)
	screen_size = get_viewport_rect().size
	hunger = rand_range(20,200)
	var f = rand_range(0,1)
	v = Vector2(f*speed, (1-f)*speed)
	set_type("prof")

func _process(delta):
	position += v * delta

func get_tag():
	return "enemy"

func _on_Enemy_area_entered(area):
	if area.get_tag() == "bullet":
		saturation += area.get_nv()
		print(saturation)
		for substance in area.substances:
			if substance in allergies:
				print("killed someone because of " + substance)
				area.queue_free()
				queue_free()
		area.queue_free()
		if saturation > hunger:
			queue_free()
	




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

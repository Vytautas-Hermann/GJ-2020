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
var bill = 0
var vegan = false

func set_type(t):
	type = t

# Called when the node enters the scene tree for the first time.
func _ready():
	for allergy in available_allergies:
		if rand_range(0,1) < available_allergies[allergy]:
			allergies.append(allergy)
	if rand_range(0,1) < 0.5:
		vegan=true
	position = Vector2(0,400)
	speed = rand_range(100,200)
	screen_size = get_viewport_rect().size
	hunger = rand_range(20,200)
	var f = rand_range(0,1)
	v = Vector2(1, 0)
	set_type("prof")

func _process(delta):
	position += v * delta * speed

func get_tag():
	return "enemy"

func get_bill():
	return bill

func hungry():
	if saturation > hunger:
		return false
	return true

func _on_Enemy_area_entered(area):
	if area.get_tag() == "bullet":
		var edible = true
		if vegan:
			if not area.vegan:
				print("I'M VEGAN")
				edible = false
		if hungry() and edible:
			saturation += area.get_nv()
			bill += area.get_price()
			for substance in area.substances:
				if substance in allergies:
					print("killed someone because of " + substance)
					area.queue_free()
					queue_free()
			area.queue_free()
	




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

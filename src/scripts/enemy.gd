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
var direction
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
	set_type("prof")
	position = Vector2(50,850)
	direction = Vector2(1, 1/speed)
	v = Vector2(speed, speed)

func _process(delta):
	var newPos = position + direction * delta
	newPos += Vector2(50, 50) * direction
	var lastDirection = direction
	#print(newPos)
	var i
	var j
	var nextField = _toField(newPos)
	if (_nextField0(nextField.x, nextField.y)):
		var dirx = direction.y
		var diry = direction.x
		nextField = nextField - Vector2(dirx, diry)
		# oben
		i = nextField.x -1
		j = nextField.y
		direction = Vector2(1/-speed, -1)		
		if (_nextField0(i,j)):
			# links
			i = nextField.x
			j = nextField.y - 1
			direction = Vector2(-1, 1/-speed)
			if _nextField0(i, j):
				# rechts
				i = nextField.x
				j = nextField.y + 1
				direction = Vector2(1, 1/speed)
				if _nextField0(i, j):
					# unten
					i = nextField.x + 1
					j = nextField.y
					direction = Vector2(1/speed, 1)
				
	
	position += direction * v * delta

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
	
func _nextField0(i, j):
	return get_node("/root/Game/Game_Board").get("caf")[i][j] == 0


func _toField(vector):
	var x = vector.x
	var y = vector.y
	var i = 0
	var j = 0
	while x > 100:
		x-=100
		j+=1
	while y > 100:
		y-=100
		i+=1
	return Vector2(i, j)
	


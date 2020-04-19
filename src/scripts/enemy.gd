extends Area2D
#allergies and their probabilities
var available_allergies = {
	"gluten": 0.05, 
	"lactose": 0.1, 
	"diabetis": 0.005, 
	"fish": 0.125
	}
var vegan_prob = 0.2
var speed
var type
var allergies = []
var saturation = 0
var hunger
var direction
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
		$AnimatedSprite.set_animation("normal"+str(int(rand_range(0,4))))
	if rand_range(0,1) < vegan_prob:
		vegan=true
		$AnimatedSprite.set_animation("vegan"+str(int(rand_range(0,2))))
	position = Vector2(0,400)
	speed = rand_range(50,300)
	var max_hunger = get_node("/root/Game/Camera2D/CanvasLayer").max_hunger
	hunger = rand_range(max_hunger/2, max_hunger)
	if speed < 100:
		$AnimatedSprite.scale.y *= 1.2
		hunger = rand_range(max_hunger*0.75, max_hunger)
	if speed > 200:
		$AnimatedSprite.scale.y *= 0.8
	hunger = rand_range(max_hunger*0.25, max_hunger)
	screen_size = get_viewport_rect().size
	set_type("prof")
	position = Vector2(50,850)
	direction = Vector2(1, 0)
	v = Vector2(speed, 1)
	

	


func _process(delta):
	var newPos = position + direction * delta
	newPos += Vector2(50, 50) * direction
	var newDirection
	var i
	var j
	var nextField = _toField(newPos)
	if (_nextField0(nextField.x, nextField.y)):
		var dirx = direction.y
		var diry = direction.x
		nextField = nextField - Vector2(dirx, diry)
		# rechts
		i = nextField.x
		j = nextField.y + 1
		newDirection = Vector2(1, 0)
		if (newDirection != Vector2(-1,-1)*direction && !_nextField0(i,j)):
			direction = newDirection
			v = Vector2(speed, 1)
			rotation = Vector2(0,-1).angle()
		else:
			# links
			i = nextField.x
			j = nextField.y - 1
			newDirection = Vector2(-1, 0)
			if (newDirection != Vector2(-1,-1)*direction && !_nextField0(i,j)):
				direction = newDirection
				v = Vector2(-speed, -1)
				rotation = Vector2(0,1).angle()
			else:
				# unten
				i = nextField.x + 1
				j = nextField.y
				newDirection = Vector2(0, 1)
				if (newDirection != Vector2(-1,-1)*direction && !_nextField0(i,j)):
					direction = newDirection
					v = Vector2(1, speed)
					rotation = Vector2(1,0).angle()
				else:
					# oben
					i = nextField.x -1
					j = nextField.y
					newDirection = Vector2(0, -1)
					if (newDirection != Vector2(-1,-1)*direction && !_nextField0(i,j)):
						direction = newDirection
						v = Vector2(-1,-speed)
						rotation = Vector2(-1,0).angle()
	
	position += v * delta

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
				if get_node("/root/Game/Camera2D/CanvasLayer").maze:
					var pop = get_node("/root/Game/Camera2D/CanvasLayer/Vegan")
					popupTimer(pop)
				edible = false
		if hungry() and edible:
			saturation += area.get_nv()
			if not hungry():
				$Lebensanzeige/Gruen.scale.x = 0.1
			else:
				var percent = 0.1*saturation/hunger
				$Lebensanzeige/Gruen.scale.x = percent
			
			bill += area.get_price()
			for substance in area.substances:
				if substance in allergies:
					print("killed someone because of " + substance)
					if get_node("/root/Game/Camera2D/CanvasLayer").maze:
						var pop = get_node("/root/Game/Camera2D/CanvasLayer/Allergy")
						popupTimer(pop)
					area.queue_free()
					queue_free()
			area.queue_free()
	
func _nextField0(i, j):
	return get_node("/root/Game/Game_Board").get("caf")[i][j] != 1

		
		
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
	
func popupTimer(popup):
	yield(get_tree().create_timer(1.0), "timeout")
	popup.popup()
	yield(get_tree().create_timer(1.0), "timeout")
	popup.hide()


extends Area2D

var speed
var saturation = 0
var hunger
var direction
var v
var bill = 0
var rn

func _ready():
	rn = get_node("/root/Game")
	$AnimatedSprite.set_animation("normal%s" % int(rand_range(0, 6)))
	
	speed = rand_range(rn.enemy_min_speed, rn.enemy_max_speed)
	hunger = rand_range(rn.enemy_min_hunger, rn.enemy_max_hunger)
	if speed < 100:
		$AnimatedSprite.scale.y *= 1.2
	if speed > 150:
		$AnimatedSprite.scale.y *= 0.8
	
	position = Vector2(-50,850)
	direction = Vector2(1, 0)
	v = Vector2(speed, 1)

func _process(delta):
	position += v * delta

func _physics_process(delta):
	var newPos = position + direction * delta + Vector2(50, 50) * direction
	var nextField = _to_field(newPos)
	if _next_field(nextField.x, nextField.y) != 1:
		nextField = _to_field(position)
		if direction.x != 0:
			if _next_field(nextField.x, nextField.y + 1) == 1: # runter
				direction = Vector2(0, 1)
				v = Vector2(1, speed)
				rotation = Vector2(1,0).angle()
			else: # hoch
				direction = Vector2(0, -1)
				v = Vector2(-1,-speed)
				rotation = Vector2(-1,0).angle()
		else:
			if _next_field(nextField.x + 1, nextField.y) == 1: # rechts
				direction = Vector2(1, 0)
				v = Vector2(speed, 1)
				rotation = Vector2(0,-1).angle()
			else: # links
				direction = Vector2(-1, 0)
				v = Vector2(-speed, -1)
				rotation = Vector2(0,1).angle()

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
		if hungry() and edible:
			saturation += area.get_nv()
			if not hungry():
				$Lebensanzeige/Gruen.scale.x = 0.1
			else:
				var percent = 0.1*saturation/hunger
				$Lebensanzeige/Gruen.scale.x = percent
			
			bill += area.get_price()
	
func _next_field(x, y):
	return get_node("/root/Game/GameBoard").get("board")[y][x]

func _to_field(vector):
	return Vector2(int(vector.x/100), int(vector.y/100))

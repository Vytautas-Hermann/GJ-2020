extends Area2D

enum {TYPE, DAMAGE, SPEED, PRICE, EXPIRE}

# TYPE, DAMAGE, SPEED, PRICE, EXPIRE
var stats = [0, 0, 0, 0, 3]
var direction

func _ready():
	$DeathTimer.wait_time = stats[EXPIRE]
	$DeathTimer.start()

func _set_type(value):
	stats[TYPE] = value
	$AnimatedSprite.set_animation("b%s" % value)

func _set_damage(value):
	stats[DAMAGE] = value

func _set_speed(value):
	stats[SPEED] = value

func _set_price(value):
	stats[PRICE] = value

func _set_direction(value):
	direction = value.normalized()

func get_price():
	return stats[PRICE]

func get_damage():
	return stats[DAMAGE]

func get_tag():
	return "bullet"

func _process(delta):
	position += direction * stats[SPEED] * delta

func _on_DeathTimer_timeout():
	queue_free()

extends Area2D

enum {BULLET_SPEED, ATTACK_SPEED, RANGE, MULTISHOOT}
enum {VALUE, LEVEL, COST, BASE}

var _ignore_return_value

# VALUE, LEVEL, COST, BASE
var stats = [[350, 0, 5, 1.66],
			 [2, 0, 10, 1.66],
			 [20, 0, 10, 1.66],
			 [1, 0, 30, 1.66]]

var munition = "res://src/prefab/Bullet.tscn"
var rn

# inits upgrade buttons
func _ready():
	rn = get_node("/root/Game")
	_ignore_return_value = $UPBS.connect("pressed", self, "_upbs")
	$UPBS/Cost.text = "%s" % get_next_cost(BULLET_SPEED)
	_ignore_return_value = $UPAS.connect("pressed", self, "_upas")
	$UPAS/Cost.text = "%s" % get_next_cost(ATTACK_SPEED)
	_ignore_return_value = $UPR.connect("pressed", self, "_upr")
	$UPR/Cost.text = "%s" % get_next_cost(RANGE)
	_ignore_return_value = $UPM.connect("pressed", self, "_upm")
	$UPM/Cost.text = "%s" % get_next_cost(MULTISHOOT)
	$FireTimer.start()

# levels bullet speed if enougth money is available
func _upbs():
	if rn.update_money(-get_next_cost(BULLET_SPEED)):
		stats[BULLET_SPEED][VALUE] *= 1.25
		stats[BULLET_SPEED][LEVEL] += 1
		$UPBS/Cost.text = "%.2f" % get_next_cost(BULLET_SPEED)

# levels attack speed if enougth money is available
func _upas():
	if rn.update_money(-get_next_cost(ATTACK_SPEED)):
		stats[ATTACK_SPEED][VALUE] *= 0.75
		stats[ATTACK_SPEED][LEVEL] += 1
		$FireTimer.wait_time = stats[ATTACK_SPEED][VALUE]
		$UPAS/Cost.text = "%.2f" % get_next_cost(ATTACK_SPEED)

# levels range if enougth money is available
func _upr():
	if rn.update_money(-get_next_cost(RANGE)):
		stats[RANGE][VALUE] *= 1.25
		stats[RANGE][LEVEL] += 1
		$CollisionShape2D.scale = Vector2(stats[RANGE][VALUE], stats[RANGE][VALUE])
		$UPR/Cost.text = "%.2f" % get_next_cost(RANGE)

# levels multishoot if enougth money is available
func _upm():
	if rn.update_money(-get_next_cost(MULTISHOOT)):
		stats[MULTISHOOT][VALUE] += 1
		stats[MULTISHOOT][LEVEL] += 1
		$UPM/Cost.text = "%.2f" % get_next_cost(MULTISHOOT)

# computes the cost of the next level up for given stat
func get_next_cost(index):
	return stats[index][COST] * pow(stats[index][BASE], stats[index][LEVEL])

# returns "tower"
func get_tag():
	return "tower"

# gets all enemies in range and shoots a bullet to each if it has enougth multishoot
func _on_FireTimer_timeout():
	# get enemies
	var areas = get_overlapping_areas()
	var enemies = []
	for area in areas:
		if area.get_tag() == "enemy":
			if area.hungry():
				enemies.append(area)
	# shoot a bullet to each if enougth multishoot
	for i in range(0, stats[MULTISHOOT][VALUE]):
		if i < enemies.size():
			var enemy = enemies[i]
			var bullet = load(munition).instance()
			var chosen_bullet = rn.shoot_bullet()
			if chosen_bullet.size() > 0:
				bullet._set_type(chosen_bullet[0][0])
				bullet._set_damage(chosen_bullet[0][1])
				bullet._set_speed(stats[BULLET_SPEED][VALUE] * chosen_bullet[0][2])
				bullet._set_price(chosen_bullet[0][3])
				bullet._set_direction(enemy.position - position)
				add_child(bullet)

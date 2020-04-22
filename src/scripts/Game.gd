extends Node2D

enum {RAT, CHICKEN, PIG, COW, DEER, CHEESE, POTATO, CUCUMBER, TOMATO, SALAD,
	  RICE, BUN, NOODLE, HUNTER_SAUCE, TOMATO_SAUCE, CURRY_SAUCE}
enum {RESOURCE_NAME, RESOURCE_CLASS, RESOURCE_AMOUNT, RESOURCE_COST, RESOURCE_DAMAGE}
enum {NONE, MEAT, VEGETABLE, CEREAL, SAUCE}
enum {RESOURCE_CLASS_NAME, RESOURCE_CLASS_AMOUNT, RESOURCE_CLASS_AFFILIATED}
enum {BULLET_NAME, BULLET_AMOUNT, BULLET_DAMAGE_FACTOR, BULLET_PRICE,
	  BULLET_RESOURCE_COST, BULLET_RESOURCE_CLASS_COST}
enum {BUILDING_NAME, BUILDING_COST, BUILDING_OBJECT}

var _ignore_return_value

var money = 200
var health = 100
var score = 0

var resource_sum = 0
# RESOURCE_NAME, RESOURCE_CLASS, RESOURCE_AMOUNT, RESOURCE_COST, RESOURCE_DAMAGE
var resources = [["Rat", MEAT, 0, 0.01, 0.9],
				 ["Chicken", MEAT, 0, 0.25, 1.2],
				 ["Pig", MEAT, 0, 0.3, 1.3],
				 ["Cow", MEAT, 0, 0.35, 1.4],
				 ["Deer", MEAT, 0, 0.5, 1.8],
				 ["Cheese", NONE, 0, 0.2, 1.3],
				 ["Potato", VEGETABLE, 0, 0.1, 1.1],
				 ["Cucumber", VEGETABLE, 0, 0.15, 1.15],
				 ["Tomato", VEGETABLE, 0, 0.15, 1.15],
				 ["Salad", VEGETABLE, 0, 0.1, 1.05],
				 ["Rice", CEREAL, 0, 0.1, 1.05],
				 ["Bun", CEREAL, 0, 0.2, 1.1],
				 ["Noodle", CEREAL, 0, 0.2, 1.15],
				 ["Hunter sauce", SAUCE, 0, 0.15, 1.2],
				 ["Tomato sauce", SAUCE, 0, 0.2, 1.15],
				 ["Curryn sauce", SAUCE, 0, 0.25, 1.3]]
# RESOURCE_CLASS_NAME, RESOURCE_CLASS_AMOUNT, RESOURCE_CLASS_AFFILIATED
var resource_classes = [["None", 0, [CHEESE]],
						["Meat", 0, [RAT, CHICKEN, PIG, COW, DEER]],
						["Vegetable", 0, [POTATO, CUCUMBER, TOMATO, SALAD]],
						["Cereal", 0, [BUN, RICE, NOODLE]],
						["Sauce", 0, [HUNTER_SAUCE, CURRY_SAUCE, TOMATO_SAUCE]]]

var bullet_sum = 0
# BULLET_NAME, BULLET_AMOUNT, BULLET_DAMAGE_FACTOR, BULLET_PRICE, BULLET_RESOURCE_COST, BULLET_RESOURCE_CLASS_COST
var bullets = [["Chips", 0, 2, 2.5, [[POTATO, 3]], []],
			   ["Rice", 0, 2, 2.25, [[RICE, 3]], []],
			   ["Salad", 0, 2, 2.75, [], [[VEGETABLE, 3]]],
			   ["Burger", 0, 2, 6, [[CHEESE, 1], [BUN, 1]], [[MEAT, 1], [VEGETABLE, 1]]], 
			   ["Pasta", 0, 2, 5, [[CHEESE, 1], [NOODLE, 1]], [[SAUCE, 1]]],
			   ["Schnitzel", 0, 2, 6.5, [[BUN, 1], [POTATO, 1]], [[MEAT, 1], [SAUCE, 1]]],
			   ["Soup", 0, 2, [], 4.5, [[MEAT, 1], [VEGETABLE, 1], [SAUCE, 1]]]]

# BUILDING_NAME, BUILDING_COST, BUILDING_OBJECT
var buildings = [["Tower", 10, "res://src/prefab/tower/Tower.tscn"],
				 ["Production", 10, "res://src/prefab/tower/Production.tscn"],
				 ["Import", 5, "res://src/prefab/tower/Import.tscn"]]

# enemy stat range
var mob = "res://src/prefab/Enemy.tscn"
var respawn = 1
var enemy_min_speed = 50
var enemy_max_speed = 200
var enemy_min_hunger = 2.5
var enemy_max_hunger = 5

var menu
var cooldown = 1
var built = -1

var storage = {"Chips": [],
					  "Rice": [],
					  "Salad": [],
					  "Burger": [],
					  "Pasta": [],
					  "Schnitzel": [],
					  "Soup": []}

func _ready():
	$SpawnTimer.wait_time = cooldown
	$Cooldown.start()

# inits most values and text in the menu
func _init_menu_bar():
	menu = $MousePosition/Camera2D/CanvasLayer/MenuBar
	menu._set_money(money)
	menu._set_health(health)
	menu._set_score(score)
	menu._set_resource_sum(resource_sum)
	menu._set_bullet_sum(bullet_sum)
	for i in range(0, resources.size()):
		menu._set_resource(i, resources[i][RESOURCE_NAME], resources[i][RESOURCE_AMOUNT])
	for i in range(0, bullets.size()):
		menu._set_bullet(i, bullets[i][BULLET_NAME], bullets[i][BULLET_AMOUNT])
	for i in range(0, buildings.size()):
		menu._set_build_cost(i, buildings[i][BUILDING_NAME], buildings[i][BUILDING_COST])

# adds positive/negativ values to money and updates displays
# returns false if money would get bellow zero otherwise true
func update_money(value):
	if money + value < 0:
		return false
	else:
		money += value
		menu._set_money(money)
		return true

# adds positive/negativ values to health and updates displays
func _update_health(value):
	health += value
	if health <= 0:
		global.score = score
		_ignore_return_value = get_tree().change_scene("res://src/scenes/GameOver.tscn")
	else:
		menu._set_health(health)

# adds positive/negativ values to score and updates displays
func _update_score(value):
	score += value
	menu._set_score(score)
	if not score % 15:
		enemy_min_hunger *= 1.5
		enemy_max_hunger *= 1.5
	if not score % 30:
		get_node("/root/Game/SpawnTimer").wait_time *= 0.75

# adds positive/negativ values to given resource and updates displays
# returns false if resource would get bellow zero otherwise true
func update_resource(index, value):
	if resources[index][RESOURCE_AMOUNT] + value < 0:
		return false
	else:
		resource_sum += value
		resources[index][RESOURCE_AMOUNT] += value
		resource_classes[resources[index][RESOURCE_CLASS]][RESOURCE_CLASS_AMOUNT] += value
		menu._set_resource_sum(resource_sum)
		menu._set_resource(index, resources[index][RESOURCE_NAME], resources[index][RESOURCE_AMOUNT])
		return true

# buys given recource value-times for it's cost
# returns false if the player hasn't enought money
# atm the function can sell resources for the same cost if the value is negativ
func buy_resource(index, value):
	if update_money(-value * resources[index][RESOURCE_COST]):
		return update_resource(index, value)
	else:
		return false

# creates a given bullet value-times for it's resources
# if there aren't enougth resources no bullets will be created
# then the function will return false otherwise true
func produce_bullet(index, value):
	var damage = update_resources(bullets[index][BULLET_RESOURCE_COST], value)
	if damage > 0:
		damage *= update_resource_classes(bullets[index][BULLET_RESOURCE_CLASS_COST], value)
		if damage > 0:
			bullet_sum += value
			bullets[index][BULLET_AMOUNT] += value
			storage[bullets[index][BULLET_NAME]].append({"nv": damage * bullets[index][BULLET_DAMAGE_FACTOR], "price": bullets[index][BULLET_PRICE]})
			menu._set_bullet_sum(bullet_sum)
			menu._set_bullet(index, bullets[index][BULLET_NAME], bullets[index][BULLET_AMOUNT])
			return true
		# if we had not enougth resources in each class we can put back the recorces we've already took
		else:
			update_resources(bullets[index][BULLET_RESOURCE_COST], -value)
	return false

# takes the resources from the list value-times and calculates a damage factor
# the list is an array with following structure [[RESOURCE_INDEX, AMOUNT], ...]
# returns a positiv damage factor if all resources where available
func update_resources(list, value):
	var damage = 1
	var fail = false
	var taken_list = []
	for i in list:
		if !fail:
			# we take all resources directly if we miss one we can't create whatever
			# so if we fail we don't take any other resources and afterwards put back what we have taken
			if !update_resource(i[0], i[1] * value):
				damage *= 0
				fail = true
			else:
				damage *= pow(resources[i[0]][RESOURCE_DAMAGE], i[1])
				taken_list.append(i)
	if fail:
		_ignore_return_value = update_resources(taken_list, -value)
	return damage

# takes the resources from each class in the list value-times and calculates a damage factor
# the list is an array with following structure [[RESOURCE_INDEX, AMOUNT], ...]
# returns a positiv damage factor if all resources where available
func update_resource_classes(list, value):
	var damage = 1
	var fail = false
	var taken_list = []
	for i in list:
		if !fail:
			var local_damage = 1
			var amount_needed = i[1] * value
			for j in resource_classes[i[0]][RESOURCE_CLASS_AFFILIATED]:
				taken_list.append([j, resources[j][RESOURCE_AMOUNT]])
				amount_needed -= resources[j][RESOURCE_AMOUNT]
				update_resource(j, -resources[j][RESOURCE_AMOUNT])
			if amount_needed > 0:
				damage *= 0
				fail = true
			else:
				damage *= pow(local_damage, 1 / value)
	if fail:
		_ignore_return_value = update_resources(taken_list, -value)
	return damage

# the countdown for creeps starts when the cooldown runs out
func _on_Cooldown_timeout():
	$SpawnTimer.wait_time = respawn
	$SpawnTimer.start()

# spawns each time an enemy when the timer expires
func _on_Timer_timeout():
	var enemy = load(mob).instance()
	enemy.rotation = Vector2(0,-1).angle()
	$Creeps.add_child(enemy)

# makes the MousePosition Node follow the Mouse
func _process(_delta):
	$MousePosition.position = get_global_mouse_position()

# sets the building you want to built
func _on_build_pressed(id):
	built = id

# handels zoom and building
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			$MousePosition/Camera2D._zoom_in()
		if event.button_index == BUTTON_WHEEL_DOWN:
			$MousePosition/Camera2D._zoom_out()
		# sets the tower on the desired field if one is choosen
		if event.button_index == BUTTON_LEFT:
			if built > 0:
				if event.pressed:
					var pos = Vector2(int($MousePosition.position.x/100), int($MousePosition.position.y/100))
					if $GameBoard.get("board")[pos.y][pos.x] == 0:
						if update_money(-buildings[built][BUILDING_COST]):
							buildings[built][BUILDING_COST] *= 1.25
							var tower = load(buildings[built][BUILDING_OBJECT]).instance()
							tower.position = Vector2(50 + pos.x * 100, 50 + pos.y * 100)
							$GameBoard.add_child(tower)
							$GameBoard.get("board")[pos.y][pos.x] = 3
		# resets the actual building you want to place to nothing
		if event.button_index == BUTTON_RIGHT:
			if event.pressed:
				built = -1

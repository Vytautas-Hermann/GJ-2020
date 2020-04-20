extends CanvasLayer

var score = 0
export var money = 200
export var max_hunger = 5
var health = 100
var rawCount = 0
var bulletCount = 0
var maze = true
var built = -1
var cost = [10, 10, 10, 5]
export var buildings = []
export var bulletName = ["Chips: %s", "Rice: %s", "Salad: %s", "Burger: %s", 
		"Pasta: %s", "Schnitzel: %s", "Soup: %s"]
export var bullet = [0,0,0,0,0,0,0]
export var rohName = ["Rat: %s", "Chicken: %s", "Pig: %s", "Cow: %s", "Deer: %s",
		"Cheese: %s", "Potato: %s", "Cucumber: %s", "Tomato: %s", "Salat: %s", 
		"Rice: %s", "Bun: %s", "Noodle Bad: %s", "Noodle Avg: %s", "Hunter sauce: %s",
		"Tomato sauce: %s", "Curryn sauce: %s"]
export var roh = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var rohCost = [0.01, 0.25, 0.3, 0.35, 0.5, 0.2, 0.1, 0.15, 0.15, 0.1, 0.1, 0.2, 0.2, 0.3, 0.15, 0.2, 0.25]
var rohNV = [0.9, 1.2, 1.3, 1.4, 1.8, 1.3, 1.1, 1.15, 1.15, 1.05, 1.05, 1.1, 1.15, 1.3, 1.2, 1.15, 1.3]

export var storage = {
	"Chips": [],
	"Rice": [],
	"Salad": [],
	"Burger": [],
	"Pasta": [],
	"Schnitzel": [],
	"Soup": []
}

func _ready() -> void:
	$MoneyTextControl/MoneyText.text="%s" % money
	$HealthControl/HealthText.text="%s" % health
	$ScoreControl/ScoreText.text="%s" % score
	$BulletControl/BulletText.text="%s" % bulletCount
	$RawControl/RawText.text="%s" % rawCount
	$MenuControl/MenuButton.get_popup().add_item("Main Menu")
	$MenuControl/MenuButton.get_popup().connect("id_pressed", self, "_on_item_pressed")
	$Recipe.connect("pressed", self,"_toggle")
	$Button.connect("pressed", self,"_swap")
	_set_maze_built()
	_init_roh()
	_init_bullet()

func _toggle():
	$Recipe/Sprite.visible = !$Recipe/Sprite.visible

func _on_item_pressed(id):
	var item_name = $MenuControl/MenuButton.get_popup().get_item_text(id)
	if item_name == "Main Menu":
		_on_mainMenu()

func _on_mainMenu():
	get_tree().change_scene("res://src/scenes/Title.tscn")

func _swap():
	if maze:
		get_parent().offset = Vector2(0,1100)
		_set_kit_built()
		maze=false
	else:
		get_parent().offset = Vector2(0,0)
		_set_maze_built()
		maze=true

func _change_money(var bal):
	if money + bal < 0:
		return false
	money += bal
	$MoneyTextControl/MoneyText.text="%.2f" % money
	return true
	

func _decrease_health(var loss):
	health -= loss
	$HealthControl/HealthText.text="%s" % health
	if health<=0:
		global.score = score
		get_tree().change_scene("res://src/scenes/GameOver.tscn")

func _increase_score(var add):
	score += add
	$ScoreControl/ScoreText.text="%s" % score
	if not score % 15:
		max_hunger *= 1.5
	if not score % 30:
		get_node("/root/Game/SpawnTimer").wait_time *= 0.75

func _set_maze_built():
	for child in $BuildControl/BuildMenue.get_popup().items:
		$BuildControl/BuildMenue.get_popup().remove_item(0)
	$BuildControl/BuildMenue.get_popup().add_item("Tower: %.2f" % cost[0])
	$BuildControl/BuildMenue.get_popup().connect("id_pressed", self, "_on_build_pressed")

func _set_kit_built():
	for child in $BuildControl/BuildMenue.get_popup().items:
		$BuildControl/BuildMenue.get_popup().remove_item(0)
	$BuildControl/BuildMenue.get_popup().add_item("Side Dish: %.2f" % cost[1])
	$BuildControl/BuildMenue.get_popup().add_item("Dish: %.2f" % cost[2])
	$BuildControl/BuildMenue.get_popup().add_item("Import: %.2f" % cost[3])
	$BuildControl/BuildMenue.get_popup().connect("id_pressed", self, "_on_build_pressed")

func _on_build_pressed(id):
	built = id

func _init_roh():
	for i in range(0, rohName.size()):
		$RawControl/Roh.get_popup().add_item(rohName[i] % roh[i])

func _init_bullet():
	for i in range(0, bulletName.size()):
		$BulletControl/Bullet.get_popup().add_item(bulletName[i] % bullet[i])

func _update_roh(idx, val):
	if val > 0:
		if _change_money(-val*rohCost[idx]):
			roh[idx] += val
			rawCount += val
	else:
		roh[idx] += val
		rawCount += val
	$RawControl/Roh.get_popup().set_item_text(idx, rohName[idx] % roh[idx])
	$RawControl/RawText.text="%s" % rawCount

func _update_bullet(idx, val):
	var mulBeilage = 2
	var mulGericht = 3
	if val > 0:
		if idx == 0:
			if roh[6]>=3*val:
				_update_roh(6, -3*val)
				bullet[idx] += val
				bulletCount += val
				storage['Chips'].append({"nv": pow(rohNV[idx], 3)*mulBeilage, "price": 2.5})
		if idx == 1:
			if roh[10]>=3*val:
				_update_roh(10, -3*val)
				bullet[idx] += val
				bulletCount += val
				storage['Rice'].append({"nv": pow(rohNV[idx], 3)*mulBeilage, "price": 2.25})
		if idx == 2:
			if roh[6]+roh[7]+roh[8]+roh[9]>=3*val:
				var mul = _from_to(6,9,-3*val)
				bullet[idx] += val
				bulletCount += val
				storage['Salad'].append({"nv": mul*mulBeilage, "price": 2.75})
		if idx == 3:
			if roh[0]+roh[1]+roh[2]+roh[3]+roh[4] >= val && roh[5] >= val && roh[6]+roh[7]+roh[8]+roh[9] >= val && roh[11] >= val:
				var mul = _from_to(0,4,val)
				_update_roh(5, -val)
				mul *= _from_to(6,9,val)
				_update_roh(11, -val)
				bullet[idx] += val
				bulletCount += val
				storage['Burger'].append({"nv": mul * rohNV[5] * rohNV[11]*mulGericht, "price": 6})
		if idx == 4:
			if roh[12]+roh[13]>=val&&roh[5]>=val&&roh[14]+roh[15]+roh[16]>=val:
				var mul = _from_to(12,13,val)
				mul *= _from_to(14,16,val)
				_update_roh(5, -val)
				bullet[idx] += val
				bulletCount += val
				storage['Pasta'].append({"nv": mul * rohNV[5]*mulGericht, "price": 5})
		if idx == 5:
			if roh[0]+roh[1]+roh[2]+roh[3]+roh[4] >= val &&roh[6]>=val&&roh[11]>=val&&roh[14]+roh[15]+roh[16]>=val:
				var mul = _from_to(0,4,val)
				mul *= _from_to(6,9,val)
				_update_roh(11, -val)
				_update_roh(6, -val)
				bullet[idx] += val
				bulletCount += val
				storage['Schnitzel'].append({"nv": mul * rohNV[6] * rohNV[11]*mulGericht, "price": 6.5})
		if idx == 6:
			if roh[0]+roh[1]+roh[2]+roh[3]+roh[4] >= val &&roh[14]+roh[15]+roh[16]>=val&&roh[6]+roh[7]+roh[8]+roh[9]:
				var mul = _from_to(0,4,val)
				mul *= _from_to(6,9,val)
				mul *= _from_to(14,16,val)
				bullet[idx] += val
				bulletCount += val
				storage['Soup'].append({"nv": mul*mulGericht, "price": 4.5})
	else:
		bullet[idx] += val
		bulletCount += val
	$BulletControl/Bullet.get_popup().set_item_text(idx, bulletName[idx] % bullet[idx])
	$BulletControl/BulletText.text="%s" % bulletCount

func _from_to(from, to, val):
	var mul = 1
	while val>0 && from <= to:
		if roh[from]>val:
			mul *= pow(rohNV[from], val)
			_update_roh(from, -val)
			val=0
		else:
			mul *= pow(rohNV[from], roh[from])
			_update_roh(from, -roh[from])
			val -= roh[from]
		from+= 1
	return mul

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if built != -1:
				if event.pressed:
					var x = event.position[0]
					var y = event.position[1]
					var i = 0
					var j = 0
					while x > 100:
						x-=100
						i+=1
					while y > 100:
						y-=100
						j+=1
					if maze:
						if get_node("/root/Game/Game_Board").get("caf")[j][i] == 0:
							if money - cost[built] > 0:
								_change_money(-cost[built])
								cost[built] *= 1.25
								_set_maze_built()
								var bu = buildings[built].instance()
								bu.position = Vector2(50 + i*100, 50 + j*100)
								get_node("/root/Game/Game_Board").add_child(bu)
								get_node("/root/Game/Game_Board").get("caf")[j][i] = 3
					else:
						if get_node("/root/Game/Game_Board").get("kitchen")[j][i] == 0:
							if money - cost[built+1] > 0:
								_change_money(-cost[built+1])
								cost[built+1] *= 1.25
								_set_kit_built()
								var bu = buildings[built+1].instance()
								bu.position = Vector2(50 + i*100, 1150 + j*100)
								get_node("/root/Game/Game_Board").add_child(bu)
								get_node("/root/Game/Game_Board").get("kitchen")[j][i] = 3
		if event.button_index == BUTTON_RIGHT:
			if event.pressed:
				built = -1

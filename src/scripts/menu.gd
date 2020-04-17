extends CanvasLayer

var score = 0
var money = 100
var health = 100
var maze = true
var built = 0
export var buildings = []

func _ready() -> void:
	$MoneyText.text="Money: %s" % money
	$HealthText.text="Health: %s" % health
	$ScoreText.text="Score: %s" % score
	$MenuButton.get_popup().add_item("Sound on/off")
	$MenuButton.get_popup().add_item("Main Menu")
	$MenuButton.get_popup().connect("id_pressed", self, "_on_item_pressed")
	$Button.connect("pressed", self,"_swap")
	_set_maze_built()

func _on_item_pressed(id):
	var item_name = $MenuButton.get_popup().get_item_text(id)
	if item_name == "Main Menu":
		_on_mainMenu()

func _on_mainMenu():
	get_tree().change_scene("res://src/scenes/Title_Screen.tscn")

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
	money += bal
	$MoneyText.text="Money: %s" % money

func _decrease_health(var loss):
	health -= loss
	$HealthText.text="Health: %s" % health

func _increase_score(var add):
	score += add
	$ScoreText.text="Score: %s" % score

func _set_maze_built():
	for child in $BuildMenue.get_popup().items:
		$BuildMenue.get_popup().remove_item(0)
	$BuildMenue.get_popup().add_item("Plate")
	$BuildMenue.get_popup().add_item("Big Plate")
	$BuildMenue.get_popup().connect("id_pressed", self, "_on_build_pressed")

func _set_kit_built():
	for child in $BuildMenue.get_popup().items:
		$BuildMenue.get_popup().remove_item(0)
	$BuildMenue.get_popup().add_item("Rice Cooker")
	$BuildMenue.get_popup().add_item("Fries")
	$BuildMenue.get_popup().connect("id_pressed", self, "_on_build_pressed")

func _on_build_pressed(id):
	var item_name = $BuildMenue.get_popup().get_item_text(id)
	if item_name == "Plate":
		built = 2
	if item_name == "Big Plate":
		built = 3
	if item_name == "Rice Cooker":
		built = 4
	if item_name == "Fries":
		built = 5

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if built != 0:
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
							var bu = buildings[built-2].instance()
							bu.position = Vector2(50 + i*100, 50 + j*100)
							get_node("/root/Game/Game_Board").add_child(bu)
							get_node("/root/Game/Game_Board").get("caf")[j][i] = built
					else:
						if get_node("/root/Game/Game_Board").get("kitchen")[j][i] == 0:
							var bu = buildings[built-2].instance()
							bu.position = Vector2(1150 + i*100, 50 + j*100)
							get_node("/root/Game/Game_Board").add_child(bu)
							get_node("/root/Game/Game_Board").get("kitchen")[j][i] = built
					built = 0

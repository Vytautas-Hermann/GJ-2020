extends CanvasLayer

var score = 0
var money = 100
var health = 100
var maze = true;

func _ready() -> void:
	$MoneyText.text="Money: %s" % money
	$HealthText.text="Health: %s" % health
	$ScoreText.text="Score: %s" % score
	$MenuButton.get_popup().add_item("Sound on/off")
	$MenuButton.get_popup().add_item("Main Menu")
	$MenuButton.get_popup().connect("id_pressed", self, "_on_item_pressed")
	$Button.connect("pressed", self,"_swap")

func _on_item_pressed(id):
	var item_name = $MenuButton.get_popup().get_item_text(id)
	if item_name == "Main Menu":
		_on_mainMenu()

func _on_mainMenu():
	get_tree().change_scene("res://src/scenes/Title_Screen.tscn")

func _swap():
	if maze:
		get_parent().offset = Vector2(0,1100)
		maze=false
	else:
		get_parent().offset = Vector2(0,0)
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
	for child in $BuildMenue.get_popup().get_children():
		child.queue_free()
	$BuildMenue.get_popup().add_item("Plate")
	$BuildMenue.get_popup().add_item("Big Plate")
	$BuildMenue.get_popup().connect("id_pressed", self, "_on_build_pressed")

func _set_kit_built():
	for child in $BuildMenue.get_popup().get_children():
		child.queue_free()
	$BuildMenue.get_popup().add_item("Rice Cooker")
	$BuildMenue.get_popup().add_item("Fries")
	$BuildMenue.get_popup().connect("id_pressed", self, "_on_build_pressed")

func _on_build_pressed():
	pass

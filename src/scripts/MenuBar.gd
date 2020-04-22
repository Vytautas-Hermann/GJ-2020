extends Panel

var _ignore_return_value

func _ready():
	$Menu.get_popup().add_item("Main Menu")
	_ignore_return_value = $Build.get_popup().connect("id_pressed", self, "_on_build_pressed")
	_ignore_return_value = $Menu.get_popup().connect("id_pressed", self, "_on_menu_pressed")
	_ignore_return_value = $Recipe.connect("pressed", self,"_on_toggle_recipe")
	get_node("/root/Game")._init_menu_bar()

func _set_money(value):
	$Money.text = "%.2f $" % value

func _set_health(value):
	$Health.text = "%s HP" % value

func _set_score(value):
	$Score.text = "%s *" % value

func _set_resource(index, name, value):
	_init_items($Resources, index)
	$Resources.get_popup().set_item_text(index, "%s: %s" % [name, value])

func _set_resource_sum(value):
	$RecourceSum.text = "%s" % value

func _set_bullet(index, name, value):
	_init_items($Bullets, index)
	$Bullets.get_popup().set_item_text(index, "%s: %s" % [name, value])

func _set_bullet_sum(value):
	$BulletSum.text = "%s" % value

func _set_build_cost(index, name, value):
	_init_items($Build, index)
	$Build.get_popup().set_item_text(index, "%s: %s $" % [name, value])

func _on_toggle_recipe():
	$Recipe/Sprite.visible = !$Recipe/Sprite.visible

func _on_build_pressed(id):
	get_node("/root/Game")._on_build_pressed(id)

func _on_menu_pressed(id):
	var item_name = $Menu.get_popup().get_item_text(id)
	if item_name == "Main Menu":
		_ignore_return_value = get_tree().change_scene("res://src/scenes/Title.tscn")

func _init_items(node, index):
	while node.get_popup().get_item_count() <= index:
		node.get_popup().add_item("")

extends Sprite

var level
var product
var prod = ["Chips", "Rice", "Salad", "Level UP: 5", "Sell"]

func _ready():
	level = 0
	product = 0
	_init_prod()
	$Timer.start()

func _on_Timer_timeout():
	get_node("/root/Game/Camera2D/CanvasLayer")._update_bullet(product, 1)

func _init_prod():
	for i in prod:
		$MenuButton.get_popup().add_item(i)
	$MenuButton.get_popup().connect("id_pressed", self, "_on_build_pressed")

func _on_build_pressed(id):
	if id < 3:
		product = id
	elif id == 3:
		if get_node("/root/Game/Camera2D/CanvasLayer")._change_money(-5*pow(1.66,level)):
			level += 1
			$MenuButton.get_popup().set_item_text(3, "Level UP: %s" % (5*pow(1.66,level)))
			$Timer.wait_time *= 0.75
	else:
		pass

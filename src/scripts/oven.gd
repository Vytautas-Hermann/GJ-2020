extends Sprite

var level
var product
var prod = ["Burger", "Pasta", "Schnitzel", "Salad"]

func _ready():
	level = 0
	product = 3
	_init_prod()
	_update_upcost()
	$Timer.start()
	$TextureButton.connect("pressed",self,"_up")

func _on_Timer_timeout():
	get_node("/root/Game/Camera2D/CanvasLayer")._update_bullet(product, 1)

func _init_prod():
	for i in prod:
		$MenuButton.get_popup().add_item(i)
	$MenuButton.get_popup().connect("id_pressed", self, "_on_build_pressed")

func _up():
	if get_node("/root/Game/Camera2D/CanvasLayer")._change_money(-5*pow(1.66,level)):
		level += 1
		_update_upcost()
		$Timer.wait_time *= 0.75

func _update_upcost():
	$TextureButton/Cost.text = "%s" % (5*pow(1.66,level))

func _on_build_pressed(id):
	product = id + 3

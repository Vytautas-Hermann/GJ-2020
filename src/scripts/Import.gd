extends Sprite

var level
var product
var prod = ["Rat", "Chicken", "Pig", "Cow", "Deer",
		"Cheese", "Potatoe", "Cucumber", "Tomatoe", "Salat", 
		"Rice", "Bun", "Noodle Bad", "Noodle Avg", "Hunter sauce",
		"Tomato sauce", "Curryn sauce", "Level UP"]

func _ready():
	level = 0
	product = 0
	_init_prod()
	$Timer.start()

func _on_Timer_timeout():
	get_node("/root/Game/Camera2D/CanvasLayer")._update_roh(product, 1)

func _init_prod():
	for i in prod:
		$MenuButton.get_popup().add_item(i)
	$MenuButton.get_popup().connect("id_pressed", self, "_on_build_pressed")

func _on_build_pressed(id):
	product = id

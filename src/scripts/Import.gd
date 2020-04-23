extends Sprite

var _ignore_return_value

var level = 0
var product = 0
var rn

# connect buttons to related functions, inits the writing of all and starts timer
func _ready():
	rn = get_node("/root/Game")
	for i in rn.resources:
		$MenuButton.get_popup().add_item(i[rn.RESOURCE_NAME])
	_ignore_return_value = $MenuButton.get_popup().connect("id_pressed", self, "_select_import")
	_ignore_return_value = $TextureButton.connect("pressed",self,"_up")
	$TextureButton/Cost.text = "%.2f" % (5*pow(1.25,level))
	$Timer.start()

# buys 1 unit of the imported product each time the timer runs out
func _on_Timer_timeout():
	_ignore_return_value = rn.buy_resource(product)

# shortens the import timer if the player has enougth money
func _up():
	if rn.update_money(-5*pow(1.25,level)):
		level += 1
		$TextureButton/Cost.text = "%.2f" % (5*pow(1.25,level))
		$Timer.wait_time *= 0.75

# changes the imported resource and picture of it
func _select_import(id):
	product = id
	$Sprite.set_animation("icon%s" % id)

extends Sprite

var _ignore_return_value

var level = 0
var product = 0
var rn

# connect buttons to related functions, inits the writing of all and starts timer
func _ready():
	rn = get_node("/root/Game")
	for i in rn.bullets:
		$MenuButton.get_popup().add_item(i[rn.BULLET_NAME])
	$MenuButton.get_popup().connect("id_pressed", self, "_select_production")
	$TextureButton/Cost.text = "%.2f" % (5*pow(1.66,level))
	_ignore_return_value = $TextureButton.connect("pressed",self,"_up")
	$Timer.start()

# produces 1 unit of the selected bullet each time the timer runs out
func _on_Timer_timeout():
	_ignore_return_value = rn.produce_bullet(product)

# shortens the production timer if the player has enougth money
func _up():
	if rn.update_money(-5*pow(1.66,level)):
		level += 1
		$TextureButton/Cost.text = "%.2f" % (5*pow(1.66,level))
		$Timer.wait_time *= 0.75

# changes the produced bullet
func _select_production(id):
	product = id

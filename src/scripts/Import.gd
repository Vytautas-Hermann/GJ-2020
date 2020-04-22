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
	_ignore_return_value = rn.buy_resource(product, 1)

# shortens the import timer if the player has enougth money
func _up():
	if rn.update_money(-5*pow(1.25,level)):
		level += 1
		$TextureButton/Cost.text = "%.2f" % (5*pow(1.25,level))
		$Timer.wait_time *= 0.75

# changes the imported resource and picture of it
func _select_import(id):
	product = id
	if id == 0:
		$Sprite.texture = load("res://.import/rat.png-18e23395d4c5625002064d339ca77bcc.stex")
	if id == 1:
		$Sprite.texture = load("res://.import/chicken.png-074e4d8f881c4892ddea06671e224a42.stex")
	if id == 2:
		$Sprite.texture = load("res://.import/pig.png-b4453315f94ec4fb927db85e58c20b4f.stex")
	if id == 3:
		$Sprite.texture = load("res://.import/cow.png-e9e525806d0c2fe42cf1e03de04a15bf.stex")
	if id == 4:
		$Sprite.texture = load("res://.import/deer.png-bf3378c6d38d426bfa65f7b793eaa669.stex")
	if id == 5:
		$Sprite.texture = load("res://.import/cheese.png-2832f92752a3c924e2cba04504a7e1a6.stex")
	if id == 6:
		$Sprite.texture = load("res://.import/potatoes.png-423bcf4cf2661c494e2cc3cd45ca5ea2.stex")
	if id == 7:
		$Sprite.texture = load("res://.import/cucumber.png-8fad98e32703c82ad6bd2c8c7a9e7bc1.stex")
	if id == 8:
		$Sprite.texture = load("res://.import/tomato.png-f567a29a221bb5dcd24118b4831489b6.stex")
	if id == 9:
		$Sprite.texture = load("res://.import/sala.png-493f223b164c141c2c0662426252157e.stex")
	if id == 10:
		$Sprite.texture = load("res://.import/rice.png-8d434eae9fa95399dd13a71fa1aab2f3.stex")
	if id == 11:
		$Sprite.texture = load("res://.import/bread1.png-565f4f56f3f11c6368cfc35214f05b63.stex")
	if id == 12:
		$Sprite.texture = load("res://.import/pasta.png-dae4e954950642bb36adf1108095eba9.stex")
	if id == 13:
		$Sprite.texture = load("res://.import/cook.png-0cd898fa6a1d2c8ccbd6dd1d2857e089.stex")
	if id == 14:
		$Sprite.texture = load("res://.import/jelly.png-8b65f49144f6e9e36b759fa167a28d48.stex")
	if id == 15:
		$Sprite.texture = load("res://.import/honey.png-d7f5dae6f144aed71f1b4ecaf8a4befb.stex")

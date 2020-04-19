extends Sprite

var level
var product
var prod = ["Rat", "Chicken", "Pig", "Cow", "Deer",
		"Cheese", "Potato", "Cucumber", "Tomato", "Salad", 
		"Rice", "Bun", "Noodle Bad", "Noodle Avg", "Hunter sauce",
		"Tomato sauce", "Curryn sauce"]

func _ready():
	level = 0
	product = 0
	_init_prod()
	_update_upcost()
	$Timer.start()
	$TextureButton.connect("pressed",self,"_up")

func _on_Timer_timeout():
	get_node("/root/Game/Camera2D/CanvasLayer")._update_roh(product, 1)

func _init_prod():
	for i in prod:
		$MenuButton.get_popup().add_item(i)
	$MenuButton.get_popup().connect("id_pressed", self, "_on_build_pressed")

func _up():
	if get_node("/root/Game/Camera2D/CanvasLayer")._change_money(-5*pow(1.25,level)):
		level += 1
		_update_upcost()
		$Timer.wait_time *= 0.75

func _update_upcost():
	$TextureButton/Cost.text = "%s" % (5*pow(1.25,level))

func _on_build_pressed(id):
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
		$Sprite.texture = load("res://.import/spaguetti.png-65e5cd39bc0ef66de0739d56335d4865.stex")
	if id == 14:
		$Sprite.texture = load("res://.import/cook.png-0cd898fa6a1d2c8ccbd6dd1d2857e089.stex")
	if id == 15:
		$Sprite.texture = load("res://.import/jelly.png-8b65f49144f6e9e36b759fa167a28d48.stex")
	if id == 16:
		$Sprite.texture = load("res://.import/honey.png-d7f5dae6f144aed71f1b4ecaf8a4befb.stex")


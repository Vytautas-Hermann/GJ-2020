extends Area2D

var munition = "res://src/prefab/bullet.tscn"
var firespeed = 350
var reload = 2 
var multishot = 1
var reach = 20
var type
var bullettype
var available_bullets = []
var towers={
	"pizza":{
		"image": "",
		"collider":{
			"position":{
				"x": 0,
				"y": 0
			},
			"scale": {
				"x": 10,
				"y": 10
			}
		},
		"sprite":{
			"position":{
				"x": 25,
				"y": -20
			},
			"scale": {
				"x": 0.5,
				"y": 0.5
			}
		}
	}
}
var cost = [5, 10, 10, 30]
var lvl = [0, 0, 0, 0]


# Called when the node enters the scene tree for the first time.
func _ready():
	$FireTimer.start()
	set_reach(reach)
	set_reload(reload)
	$UPBS.connect("pressed",self,"_upbs")
	$UPBS/Cost.text = "%s" % (cost[0]*pow(1.66,lvl[0]))
	$UPAS.connect("pressed",self,"_upas")
	$UPAS/Cost.text = "%s" % (cost[1]*pow(1.66,lvl[1]))
	$UPR.connect("pressed",self,"_upr")
	$UPR/Cost.text = "%s" % (cost[2]*pow(1.66,lvl[2]))
	$UPM.connect("pressed",self,"_upm")
	$UPM/Cost.text = "%s" % (cost[3]*pow(1.66,lvl[3]))

func _upbs():
	if get_node("/root/Game/Camera2D/CanvasLayer")._change_money(-cost[0]*pow(1.66,lvl[0])):
		lvl[0] += 1
		firespeed *= 1.25
		$UPBS/Cost.text = "%s" % (cost[0]*pow(1.66,lvl[0]))

func _upas():
	if get_node("/root/Game/Camera2D/CanvasLayer")._change_money(-cost[1]*pow(1.66,lvl[1])):
		lvl[1] += 1
		set_reload(reload * 0.75)
		$UPAS/Cost.text = "%s" % (cost[1]*pow(1.66,lvl[1]))

func _upr():
	if get_node("/root/Game/Camera2D/CanvasLayer")._change_money(-cost[2]*pow(1.66,lvl[2])):
		lvl[2] += 1
		set_reach(reach * 1.25)
		$UPR/Cost.text = "%s" % (cost[2]*pow(1.66,lvl[2]))

func _upm():
	if get_node("/root/Game/Camera2D/CanvasLayer")._change_money(-cost[3]*pow(1.66,lvl[3])):
		lvl[3] += 1
		multishot += 1
		$UPM/Cost.text = "%s" % (cost[3]*pow(1.66,lvl[3]))

func set_reach(r):
	reach = r
	$CollisionShape2D.scale.x = reach
	$CollisionShape2D.scale.y = reach


func set_firespeed(s):
	firespeed = s

func set_reload(r):
	reload = r
	$FireTimer.wait_time = reload


func set_type(t):
	type = t
	$CollisionShape2D.position.x = towers[type]['collider']['position']['x']
	$CollisionShape2D.position.y = towers[type]['collider']['position']['y']
	$CollisionShape2D.scale.x = towers[type]['collider']['scale']['x']
	$CollisionShape2D.scale.y = towers[type]['collider']['scale']['y']
	$AnimatedSprite.position.x = towers[type]['sprite']['position']['x']
	$AnimatedSprite.position.y = towers[type]['sprite']['position']['y']
	$AnimatedSprite.scale.x = towers[type]['sprite']['scale']['x']
	$AnimatedSprite.scale.y = towers[type]['sprite']['scale']['y']
	
func set_bullettype(t):
	bullettype = t
func get_tag():
	return "tower"

func _on_FireTimer_timeout():
	var areas = get_overlapping_areas()
	var enemies = []
	var cl = get_node("/root/Game/Camera2D/CanvasLayer")
	for area in areas:
		if area.get_tag() == "enemy":
			if area.hungry():
				enemies.append(area)
	#get available bullets
	for i in range(multishot):
		if i < len(enemies):
			var nv = 0
			var enemy = enemies[i]
			var allergic = false
			var bullet = load(munition).instance()
			for i in cl.storage:
				if len(cl.storage[i]) >0:
					available_bullets.append(i)
			if not len(available_bullets):
				break
			var chosentype = null #get available bullets (those, that are produced and theres more than 0 of them)
			for type in available_bullets:
				if enemy.vegan:
					if not bullet.bullets[type]["vegan"]:
						continue
				for allergy in enemy.allergies:
					if allergy in bullet.bullets[type]['substances']:
						allergic = true
				if allergic:
					allergic = false
					continue
				if cl.storage[type][0]['nv'] > nv:
					nv = cl.storage[type][0]['nv']
					chosentype = type
			if not chosentype:
				for type in available_bullets:
					if cl.storage[type][0]['nv']:
						nv =  cl.storage[type][0]['nv']
						chosentype = type
			bullet.set_type(chosentype)
			bullet.set_nv(cl.storage[chosentype][0]['nv'])
			bullet.set_price(cl.storage[chosentype][0]['price'])
			#cl = get_node("/root/Game/Camera2D/CanvasLayer").storage
			bullet.speed = firespeed
			bullet.direction = enemy.position - position
			bullet.direction = bullet.direction.normalized()
			add_child(bullet)
			available_bullets = []
			cl.storage[chosentype].erase(cl.storage[chosentype][0])
			if chosentype == "Chips":
				cl._update_bullet(0,-1)
			if chosentype == "Rice":
				cl._update_bullet(1,-1)
			if chosentype == "Salad":
				cl._update_bullet(2,-1)
			if chosentype == "Burger":
				cl._update_bullet(3,-1)
			if chosentype == "Pasta":
				cl._update_bullet(4,-1)
			if chosentype == "Schnitzel":
				cl._update_bullet(5,-1)
			if chosentype == "Soup":
				cl._update_bullet(6,-1)


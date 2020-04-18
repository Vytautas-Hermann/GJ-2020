extends Area2D

var munition = "res://src/prefab/bullet.tscn"
var firespeed = 500
var reload = 1 
var type
var bullettype
var reach
var multishot = 3
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


# Called when the node enters the scene tree for the first time.
func _ready():
	$FireTimer.start()
	set_type("pizza")
	bullettype = "pizza"
	set_reach(30)
	set_reload(1.5)

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
			bullet.nutrional_value = cl.storage[chosentype][0]['nv']
			#cl = get_node("/root/Game/Camera2D/CanvasLayer").storage
			bullet.speed = firespeed
			bullet.direction = enemy.position - position
			bullet.direction = bullet.direction.normalized()
			add_child(bullet)
			available_bullets = []
			bullet.set_deathTimer(0.2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

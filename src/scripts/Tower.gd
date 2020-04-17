extends Area2D

var munition = "res://src/prefab/bullet.tscn"
var firespeed = 2000
var reload = 1 #for changing firerate -> change firetimer waittime
var type
var bullettype
var towers={
	"pizza":{
		"image": "",
		"collider":{
			"position":{
				"x": 23,
				"y": 7
			},
			"scale": {
				"x": 5.5,
				"y": 3
			}
		},
		"sprite":{
			"position":{
				"x": 30,
				"y": 0
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


func _on_FireTimer_timeout():
	var bullet = load(munition).instance()
	bullet.set_type(bullettype)
	bullet.speed = firespeed
	add_child(bullet)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

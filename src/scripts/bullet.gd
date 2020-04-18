extends Area2D

var nutrition_value
var aerodynamical_slowfactor
var substances
var direction
var speed 
var screen_size
var type
var price
var vegan
var bullets={
	"pizza":{
		"vegan": false,
		"nutrition_value": 100,
		"aerodynamical_slowfactor": 1,
		"substances": ["lactose", "gluten"],
		"image": "Pizza.png",
		"collider":{
			"position":{
				"x": 0,
				"y": 0
			},
			"scale": {
				"x": 3,
				"y": 3
			}
		},
		"sprite":{
			"position":{
				"x": 0,
				"y": 0
			},
			"scale": {
				"x": 0.25,
				"y": 0.25
			}
		}
	},
	"rice":{
		"vegan": false,
		"nutrition_value": 50,
		"aerodynamical_slowfactor": 0.75,
		"substances": [],
		"image": "Reis.png",
		"collider":{
			"position":{
				"x": 0,
				"y": 0
			},
			"scale": {
				"x": 3,
				"y": 3
			}
		},
		"sprite":{
			"position":{
				"x": 0,
				"y": 0
			},
			"scale": {
				"x": 0.3,
				"y": 0.3
			}
		}
	},
	"noodle":{
		"vegan": true,
		"nutrition_value": 75,
		"aerodynamical_slowfactor": 0.5,
		"substances": ["gluten"],
		"image": "noodle.png",
		"collider":{
			"position":{
				"x": 0,
				"y": -12
			},
			"scale": {
				"x": 3,
				"y": 3
			}
		},
		"sprite":{
			"position":{
				"x": 0,
				"y": 0
			},
			"scale": {
				"x": 0.2,
				"y": 0.2
			}
		}
	}
}


func _ready():
	screen_size = get_viewport_rect().size
	$DeathTimer.start()
	set_price(10)

func set_price(p):
	price = p
	
func get_price():
	return price
	
	
func set_type(t):
	type = t
	$CollisionShape2D.position.x = bullets[type]['collider']['position']['x']
	$CollisionShape2D.position.y = bullets[type]['collider']['position']['y']
	$CollisionShape2D.scale.x = bullets[type]['collider']['scale']['x']
	$CollisionShape2D.scale.y = bullets[type]['collider']['scale']['y']
	$AnimatedSprite.set_animation(type)
	$AnimatedSprite.position.x = bullets[type]['sprite']['position']['x']
	$AnimatedSprite.position.y = bullets[type]['sprite']['position']['y']
	$AnimatedSprite.scale.x = bullets[type]['sprite']['scale']['x']
	$AnimatedSprite.scale.y = bullets[type]['sprite']['scale']['y']
	substances = bullets[type]['substances']
	nutrition_value = bullets[type]['nutrition_value']
	aerodynamical_slowfactor = bullets[type]['aerodynamical_slowfactor']
	vegan = bullets[type]['vegan']

func set_deathTimer(t):
	$DeathTimer.wait_time = t

func get_tag():
	return "bullet"

func get_nv():
	return nutrition_value
	
func set_nv(nv):
	nutrition_value = nv

func _process(delta):
	position += direction * speed * delta * aerodynamical_slowfactor



func _on_DeathTimer_timeout():
	queue_free()

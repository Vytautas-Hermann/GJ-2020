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
	"Chips":{
		"vegan": true,
		"aerodynamical_slowfactor": 0.5,
		"substances": [],
		"sprite":{
			"position":{
				"x": 3,
				"y": -3
			},
			"scale": {
				"x": 0.07,
				"y": 0.12
			}
		}
	},
	"Rice":{
		"vegan": false,
		"aerodynamical_slowfactor": 0.75,
		"substances": ["fish"],
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
	"Salad":{
		"vegan": true,
		"aerodynamical_slowfactor": 0.3,
		"substances": [],
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
	},
	"Burger":{
		"vegan": false,
		"aerodynamical_slowfactor": 0.9,
		"substances": ["gluten", "lactose", "diabetis"],
		"sprite":{
			"position":{
				"x": 0,
				"y": 0
			},
			"scale": {
				"x": 0.15,
				"y": 0.15
			}
		}
	},
	"Pasta":{
		"vegan": true,
		"aerodynamical_slowfactor": 0.5,
		"substances": ["gluten"],
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
	},
	"Schnitzel":{
		"vegan": false,
		"aerodynamical_slowfactor": 1,
		"substances": ["gluten"],
		"sprite":{
			"position":{
				"x": 0,
				"y": 0
			},
			"scale": {
				"x": 1.2,
				"y": 1.2
			}
		}
	},
	"Soup":{
		"vegan": true,
		"aerodynamical_slowfactor": 0.5,
		"substances": ["lactose"],
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

func set_price(p):
	price = p
	
func get_price():
	return price
	
	
func set_type(t):
	type = t
	$AnimatedSprite.set_animation(type)
	$AnimatedSprite.position.x = bullets[type]['sprite']['position']['x']
	$AnimatedSprite.position.y = bullets[type]['sprite']['position']['y']
	$AnimatedSprite.scale.x = bullets[type]['sprite']['scale']['x']
	$AnimatedSprite.scale.y = bullets[type]['sprite']['scale']['y']
	substances = bullets[type]['substances']
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

extends Node

var _ignore_return_value

var title = true

# connects buttons to each function
func _ready():
	_ignore_return_value = $Play.connect("pressed", self, "_on_new_game")
	_ignore_return_value = $Credits.connect("pressed", self, "_swap")
	_ignore_return_value = $Quit.connect("pressed", self, "_on_quit")
	_ignore_return_value = $Back.connect("pressed", self, "_swap")

# switch to game scene
func _on_new_game():
	_ignore_return_value = get_tree().change_scene("res://src/scenes/Game.tscn")

# closes the game
func _on_quit():
	get_tree().quit()

# swaps between credits and title screen
func _swap():
	if title:
		$Camera2D.position = Vector2(960,1620)
		title=false
	else:
		$Camera2D.position = Vector2(960,540)
		title=true

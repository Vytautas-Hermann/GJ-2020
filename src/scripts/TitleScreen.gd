extends Node

var _ignore_return_value

var title = true

func _ready():
	_ignore_return_value = $Play.connect("pressed", self, "_on_new_game")
	_ignore_return_value = $Credits.connect("pressed", self, "_swap")
	_ignore_return_value = $Quit.connect("pressed", self, "_on_quit")
	_ignore_return_value = $Back.connect("pressed", self, "_swap")

func _on_new_game():
	_ignore_return_value = get_tree().change_scene("res://src/scenes/Game.tscn")

func _on_quit():
	get_tree().quit()

func _swap():
	if title:
		$Camera2D.position = Vector2(960,1620)
		title=false
	else:
		$Camera2D.position = Vector2(960,540)
		title=true

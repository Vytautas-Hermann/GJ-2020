extends Node

var _ignore_return_value

# gets score and writes it into the label
func _ready():
	_ignore_return_value = $Back.connect("pressed", self, "_back")
	$Score.text = str(global.score)

# switches scene to title scene
func _back():
	_ignore_return_value = get_tree().change_scene("res://src/scenes/Title.tscn")

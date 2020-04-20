extends VBoxContainer

func _ready():
	get_node("Button").connect("pressed", self, "_back")

func _back():
	get_tree().change_scene("res://src/scenes/Title.tscn")

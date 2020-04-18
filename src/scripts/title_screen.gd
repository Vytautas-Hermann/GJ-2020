extends Node

func _ready():
	get_node("Button").connect("pressed", self, "_on_new_game")
	get_node("Button3").connect("pressed", self, "_on_credits")
	get_node("Button4").connect("pressed", self, "_on_quit")

func _on_new_game():
	get_tree().change_scene("res://src/scenes/Game.tscn")

func _on_credits():
	get_tree().change_scene("res://src/scenes/Credits.tscn")

func _on_quit():
	get_tree().quit()

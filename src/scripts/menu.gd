extends CanvasLayer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MenuButton.get_popup().add_item("Sound on/off")
	$MenuButton.get_popup().add_item("Main Menu")
	
	$MenuButton.get_popup().connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(id):
	var item_name = $MenuButton.get_popup().get_item_text(id)
	if item_name == "Main Menu":
		_on_mainMenu()

func _on_mainMenu():
	get_tree().change_scene("res://src/scenes/Title_Screen.tscn")

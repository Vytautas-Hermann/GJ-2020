extends Node

export (PackedScene) var Enemy



func _ready():
	var enemy = Enemy.instance()
	add_child(enemy)
	print(enemy.type)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

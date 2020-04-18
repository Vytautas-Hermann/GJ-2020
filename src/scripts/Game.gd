extends Node2D

var mob = "res://src/prefab/Enemy.tscn"

func _ready():
	new_game()


func new_game():
	$SpawnTimer.start()

func _on_SpawnTimer_timeout():
	var enemy = load(mob).instance()
	enemy.rotation = Vector2(0,-1).angle()
	add_child(enemy)

func _on_Timer_timeout():
	_on_SpawnTimer_timeout()

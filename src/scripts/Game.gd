extends Node2D

var mob = "res://src/prefab/Enemy.tscn"
var respawn = 3

func _ready():
	$Cooldown.start()

func new_game():
	$SpawnTimer.wait_time = respawn
	$SpawnTimer.start()

func _on_SpawnTimer_timeout():
	var enemy = load(mob).instance()
	enemy.rotation = Vector2(0,-1).angle()
	add_child(enemy)

func _on_Timer_timeout():
	_on_SpawnTimer_timeout()


func _on_Cooldown_timeout():
	new_game()

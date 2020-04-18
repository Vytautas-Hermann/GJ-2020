extends Node2D
export (PackedScene) var Enemy



func _ready():
	new_game()


func new_game():
	$SpawnTimer.start()

func _on_SpawnTimer_timeout():
	var enemy = Enemy.instance()
	enemy.rotation = Vector2(0,-1).angle()
	add_child(enemy)

func _on_Timer_timeout():
	_on_SpawnTimer_timeout()

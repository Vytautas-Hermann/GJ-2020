extends Node

export (PackedScene) var Enemy

var score

func _ready():
	new_game()


func new_game():
	score = 0
	$SpawnTimer.start()

func _on_SpawnTimer_timeout():
	$EnemyPath/EnemySpawn.offset = randi()
	var enemy = Enemy.instance()
	add_child(enemy)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

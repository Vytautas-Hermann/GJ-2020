extends Node

export (PackedScene) var Enemy

var score

func _ready():
	new_game()


func new_game():
	score = 0
	$SpawnTimer.start()
	set_respawn(0.2)

func _on_SpawnTimer_timeout():
	var enemy = Enemy.instance()
	add_child(enemy)

func set_respawn(t):
	$SpawnTimer.wait_time = t


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

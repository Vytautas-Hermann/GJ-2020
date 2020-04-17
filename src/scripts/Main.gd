extends Node

export (PackedScene) var Enemy

var score

func _ready():
	new_game()


func new_game():
	score = 0
	$SpawnTimer.start()
	$FireTimer.start()

func _on_SpawnTimer_timeout():
	print("spawning enemy")
	$EnemyPath/EnemySpawn.offset = randi()
	var enemy = Enemy.instance()
	add_child(enemy)
	var direction = $EnemyPath/EnemySpawn.rotation + PI / 2
	enemy.position = $EnemyPath/EnemySpawn.position
	direction += rand_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	enemy.linear_velocity = Vector2(enemy.speed, 0).rotated(direction)
	
func _on_FireTimer_timeout():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

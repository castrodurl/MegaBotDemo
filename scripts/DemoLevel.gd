extends Node2D

export (PackedScene) var enemy

func _ready() -> void:
	randomize()
	var rect = $TileMap.get_used_rect()
	var t_cell_size = $TileMap.cell_size
	$MegaBot/Camera2D.limit_left = rect.position.x * t_cell_size.x + 16
	$MegaBot/Camera2D.limit_right = rect.end.x * t_cell_size.x - 16

func spawn_enemy() -> void:
	var e = enemy.instance()
	$EnemySpawn/Position2D.position.y = randi() % 100 + 50
	e.position = $EnemySpawn/Position2D.global_position
	$EnemySpawn/Enemies.add_child(e)
	$EnemySpawn/RespawnTime.start()

func _on_RespawnTime_timeout() -> void:
	spawn_enemy()


func _on_MegaBot_player_has_died() -> void:
	for i in $EnemySpawn/Enemies.get_children():
		$EnemySpawn/Enemies.remove_child(i)
	get_tree().reload_current_scene()
	pass # Replace with function body.

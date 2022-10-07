extends Node

export(PackedScene) var mob_scene


func _ready():
	randomize()
	$UserInterface/Retry.hide()


func _on_MobSpawnTimer_timeout():
	var mob = mob_scene.instance()
	
	var mob_spawn_location = $SpawnPath/SpawnLocation	
	mob_spawn_location.unit_offset = randf()
	var player_position = $Player.transform.origin
	mob.initialize(mob_spawn_location.translation, player_position)
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")

	add_child(mob)


func _on_Player_hit():
	$MobSpawnTimer.stop()
	$UserInterface/Retry.show()


func _unhandled_input(event):
	if $UserInterface/Retry.visible and event.is_action_pressed("start_game"):
		get_tree().reload_current_scene()

extends Position2D

export var spawn_interval : float
export var enemy_scene : PackedScene

onready var timer : Timer = $Timer

func _ready():
	if (enemy_scene):
		timer.start(spawn_interval)
		
		
func _on_Timer_timeout():
	var enemy : Node2D = enemy_scene.instance()
	get_parent().add_child(enemy)
	enemy.global_position = global_position

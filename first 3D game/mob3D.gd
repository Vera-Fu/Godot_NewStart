extends KinematicBody

export var min_speed = 10.0
export var max_speed = 18.0

var velocity = Vector3.ZERO

signal squashed


func _physics_process(delta):
	move_and_slide(velocity)
	
func initialize(start_position, player_position):
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotation.x = 0.0
	rotate_y(rand_range(PI / -4, PI / 4))
	
	var random_speed = rand_range(min_speed, max_speed)
	
	velocity = Vector3.FORWARD * random_speed
	
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	$AnimationPlayer.playback_speed = random_speed / min_speed


func _on_VisibilityNotifier_screen_exited():
	queue_free()


func squash():
	emit_signal("squashed")
	queue_free()

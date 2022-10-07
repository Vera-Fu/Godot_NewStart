extends KinematicBody

export var speed = 14.0
export var fall_acceleration = 75.0
export var jump_impluse = 20.0
export var bounce_impluse = 16.0

var velocity = Vector3.ZERO

signal hit

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_up"):
		direction.z = -1.0
	if Input.is_action_pressed("move_down"):
		direction.z = 1.0
	if Input.is_action_pressed("move_left"):
		direction.x = -1.0
	if Input.is_action_pressed("move_right"):
		direction.x = 1.0
		
	if direction.length() != 0:
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)
		$AnimationPlayer.playback_speed = 4.0
	else:
		$AnimationPlayer.playback_speed = 1.0
		
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y += jump_impluse
		
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("mob"):		
			var mob = collision.collider
			if Vector3.UP.dot(collision.normal) > 0.1:
				mob.squash()
				velocity.y = bounce_impluse
	
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impluse			

func die():
	emit_signal("hit")
	queue_free()
	

func _on_Area_body_entered(body):
	die()
	

extends "res://Platform/Scripts/Enemy.gd"

enum Direction {
	LEFT = -1,
	RIGHT = 1
}

export(Direction) var direction = Direction.LEFT


func _process(delta):
	if (is_dead):
		velocity.x = 0
	else:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
	
	velocity.y += gravity * delta
		
	if (velocity.x != 0):
		sprite.flip_h = velocity.x > 0
	

func _physics_process(delta):
	var was_on_wall = is_on_wall()
	velocity = move_and_slide(velocity, Vector2.UP)
	if (is_on_wall() && !was_on_wall):
		direction *= -1
	



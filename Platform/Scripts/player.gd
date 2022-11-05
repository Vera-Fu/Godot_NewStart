extends KinematicBody2D

const Gravity = 2000.0

var velocity = Vector2.ZERO
export var max_speed = 350.0
export var acceleration = 0.2
export var air_acceleration = 0.05
export var jump_force = 800.0

var is_jumping = false
export var is_dead = false

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
onready var coyote_timer = $CoyoteTimer
onready var jump_request_timer = $JumpRequestTimer
onready var jump_sound = $JumpSound


func _ready():
	acceleration = max_speed / acceleration
	air_acceleration = max_speed / air_acceleration


func _input(event):
	if (is_dead):
		return
	
	if (event.is_action_pressed("jump")):
		jump_request_timer.start()
	
	if (event.is_action_released("jump") && velocity.y < -jump_force / 2):
		velocity.y = -jump_force / 2


func _process(delta):
	velocity.y += Gravity * delta
	
	if (is_dead):
		return
		
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var acc = acceleration if is_on_floor() else air_acceleration
	velocity.x = move_toward(velocity.x, direction * max_speed, acc * delta)
	
	var can_jump = (is_on_floor() or coyote_timer.time_left > 0) && !is_jumping
	if (can_jump && jump_request_timer.time_left > 0):
		velocity.y = -jump_force
		is_jumping = true
		jump_request_timer.stop()
		coyote_timer.stop()
		jump_sound.play()
	
	if (is_jumping):
		animation_player.play("jump")
	elif (velocity.x == 0):
		animation_player.play("idle")
	else:
		animation_player.play("walk")
		
	if (direction != 0):
		sprite.flip_h = direction < 0


func _physics_process(delta):
	var was_on_floor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	if (is_on_floor()):
		is_jumping = false
	elif was_on_floor && !is_jumping:
		coyote_timer.start()


func _on_HurtBox_hurt():
	velocity.y = -jump_force
	animation_player.play("death")
	WorldManager.reload_world()


func _on_HitBox_hit():
	velocity.y = -jump_force / 2


func _on_TrailTimer_timeout():
	if (velocity.x == 0):
		return
		
	var trail = preload("res://Platform/Effects/Trail.tscn").instance()
	get_parent().add_child(trail)
	get_parent().move_child(trail, get_index())
	
	var properties = [
		"hframes",
		"vframes",
		"frame",
		"texture",
		"global_position",
		"flip_h"
	]

	for name in properties:
		trail.set(name, sprite.get(name))

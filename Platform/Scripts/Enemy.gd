extends KinematicBody2D

export var gravity = 2000.0
export var max_speed = 50.0
export var acceleration = 0.2
export(bool) var is_dead = false

var velocity := Vector2.ZERO

onready var sprite : Sprite = $Sprite
onready var animation_player = $AnimationPlayer

func _ready():
	acceleration = max_speed / acceleration


func _on_HurtBox_hurt():
	if (animation_player.has_animation("death")):
		animation_player.play("death")
	else:
		queue_free()

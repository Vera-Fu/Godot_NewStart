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
	

func _on_HurtBox_hurt(hitbox):
	if (!hitbox.instant_kill && animation_player.has_animation("death")):
		animation_player.play("death")
	else:
		queue_free()


func _on_VisibilityEnabler2D_viewport_entered(viewport):
	var visibility_enabler = $VisibilityEnabler2D
	visibility_enabler.process_parent = false
	visibility_enabler.physics_process_parent = false
	visibility_enabler.pause_animations = false

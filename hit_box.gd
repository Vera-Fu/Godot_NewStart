extends Area2D

signal hit
export var instant_kill = false

func _on_HitBox_area_entered(hurtbox):
	emit_signal("hit")
	hurtbox.emit_signal("hurt", self)

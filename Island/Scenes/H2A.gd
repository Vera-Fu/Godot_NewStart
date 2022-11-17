extends "res://Island/Scenes/background.gd"

onready var board = $Board
onready var gear = $Reset/Gear


func _on_Reset_interact():
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(gear, "rotation_degrees", 360.0, 0.2).as_relative()
	tween.tween_callback(board, "reset")

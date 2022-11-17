extends Control



func _on_Button_pressed():
	yield(get_tree().create_timer(3.0), "timeout")
	print("hello")

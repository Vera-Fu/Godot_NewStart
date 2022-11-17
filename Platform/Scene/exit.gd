extends Area2D

export(String, FILE, "*.tscn") var path


func _on_Exit_body_entered(_player):
	if (path):
		WorldManager.go_to_world(path)
	else:
		WorldManager.complete_game()

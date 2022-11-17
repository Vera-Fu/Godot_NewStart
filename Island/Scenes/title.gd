extends TextureRect

onready var hud := get_node("/root/Hud")
onready var load_button = $VBoxContainer/Load


func _ready():
	hud.visible = false
	load_button.disabled = !Game.has_save_file()


func _on_TitleBackground_tree_exited():
	hud.visible = true


func _on_Start_pressed():
	Game.new_game()


func _on_Load_pressed():
	Game.load_game()


func _on_Quit_pressed():
	get_tree().quit()

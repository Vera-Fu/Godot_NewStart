extends Control

onready var transition = $UI/Menu/Transition
onready var bgm_button = $UI/Menu/Button2/BGMButton
onready var sfx_button = $UI/Menu/Button2/SFXButton


func _ready():
	bgm_button.text = "音乐：" + ("开" if WorldManager.bgm_enabled else "关")
	sfx_button.text = "音效：" + ("开" if WorldManager.sfx_enabled else "关")


func _on_OptionButton_pressed():
	transition.play("option_menu")


func _on_BackButton_pressed():
	transition.play_backwards("option_menu")


func _on_BGMButton_pressed():
	WorldManager.bgm_enabled = !WorldManager.bgm_enabled
	WorldManager.save_config()
	bgm_button.text = "音乐：" + ("开" if WorldManager.bgm_enabled else "关")	


func _on_SFXButton_pressed():
	WorldManager.sfx_enabled = !WorldManager.sfx_enabled
	WorldManager.save_config()
	sfx_button.text = "音效：" + ("开" if WorldManager.sfx_enabled else "关")	


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_StartButton_pressed():
	WorldManager.start_game()

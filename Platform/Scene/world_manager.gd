extends Node

signal coins_changed

enum AudioIndex { IDX_BGM = 1, IDX_SFX = 2 }

const CONFIG_PATH = "user://settings.cfg"

var bgm_enabled setget set_bgm_enabled, is_bgm_enabled
var sfx_enabled setget set_sfx_enabled, is_sfx_enabled

var coins_collected := 0
var coins_pending := 0 setget _set_coins_pending

var death_num := 0
var start_time = OS.get_unix_time()
var complete_time = OS.get_unix_time()

onready var animation_player = $AnimationPlayer
	
	
func _ready():
	load_config()
	

func get_coins():
	return coins_collected + coins_pending


func _set_coins_pending(value):
	coins_pending = value
	emit_signal("coins_changed")


func start_game():
	coins_collected = 0
	coins_pending = 0
	death_num = 0
	start_time = OS.get_unix_time()
	go_to_world("res://Platform/Scene/World/World01.tscn")


func complete_game():
	complete_time = OS.get_unix_time()
	_animate_transition_to("res://Platform/Scene/UI/GameComplete.tscn")


func back_to_menu():
	_animate_transition_to("res://Platform/Scene/UI/TitleScreen.tscn")


func reload_world():
	coins_pending = 0
	death_num += 1
	_animate_transition_to(null)


func go_to_world(path):
	coins_collected += coins_pending
	coins_pending = 0
	_animate_transition_to(path)
	
	
func _animate_transition_to(path):	
	animation_player.play_backwards("fade_in")
	yield(animation_player, "animation_finished")
	
	if (path):
		get_tree().change_scene(path)
	else:
		get_tree().reload_current_scene()
		
	animation_player.play("fade_in")


func is_bgm_enabled():	
	return !AudioServer.is_bus_mute(AudioIndex.IDX_BGM)
	
	
func set_bgm_enabled(value):
	AudioServer.set_bus_mute(AudioIndex.IDX_BGM, !value)
	
	
func is_sfx_enabled():
	return !AudioServer.is_bus_mute(AudioIndex.IDX_SFX)
	
	
func set_sfx_enabled(value):
	AudioServer.set_bus_mute(AudioIndex.IDX_SFX, !value)
	

func save_config():
	var file = ConfigFile.new()
	file.set_value("audio", "bgm_enabled", is_bgm_enabled())
	file.set_value("audio", "sfx_enabled", is_sfx_enabled())
	var err = file.save(CONFIG_PATH)
	if (err != OK):
		push_error("Fail to save config: %d" % err)
	
	
func load_config():
	var file = ConfigFile.new()
	var err = file.load(CONFIG_PATH)
	if (err == OK):
		set_bgm_enabled(file.get_value("audio", "bgm_enabled", true))
		set_sfx_enabled(file.get_value("audio", "sfx_enabled", true))
	else:
		push_warning("Fail to load config: %d" % err)
		set_bgm_enabled(true)
		set_sfx_enabled(true)

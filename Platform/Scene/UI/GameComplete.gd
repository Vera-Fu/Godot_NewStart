extends Control

onready var time_value = $UI/status/TimeValue
onready var death_value = $UI/status/DeathValue
onready var coins_value = $UI/status/CoinsValue


func _ready():
	var duration = WorldManager.complete_time - WorldManager.start_time
	var minutes = duration / 60
	var seconds = duration % 60
	time_value.text = "%d:%02d" % [minutes, seconds]
	death_value.text = str(WorldManager.death_num)
	coins_value.text = str(WorldManager.get_coins())

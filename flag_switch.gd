extends Node2D
class_name FlagSwitch

export var flag : String

var defalut_node : Node2D
var switch_node : Node2D


func _ready():
	var count := get_child_count()
	if (count > 0):
		defalut_node = get_child(0)
	if (count > 1):
		switch_node = get_child(1)
		
	Game.flags.connect("changed", self, "_update_node")
	_update_node()
	
	
func _update_node():
	var exists = Game.flags.has(flag)
	if (defalut_node):
		defalut_node.visible = not exists
	if (switch_node):
		switch_node.visible = exists

extends FlagSwitch


func _on_Interactable_interact():
	var item = Game.inventory.active_item
	if (!item && item != preload("res://Island/Items/mail.tres")):
		return
	
	Game.flags.add(flag)
	Game.inventory.remove_item(item)

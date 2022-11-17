extends Node

const SAVE_PATH := "user://data.sav"

class Flags:
	signal changed
	
	var _flags := []
	
	func has(flag: String) -> bool:
		return flag in _flags
		
	func add(flag: String):
		if (flag in _flags):
			return
			
		_flags.append(flag)
		emit_signal("changed")
	
	func to_dict():
		return {
			flags = _flags
		}
	
	func from_dict(dict: Dictionary):
		_flags = dict.flags
		emit_signal("changed")
		
	func reset():
		_flags.clear()
		emit_signal("changed")
		
		
class Inventory:
	signal changed
	
	var active_item : Item
	
	var _items := []
	var _current_item_index = -1
	
	func get_item_count() -> int:
		return _items.size()
		
	func get_current_item() -> Item:
		if (_current_item_index == -1):
			return null
		
		return _items[_current_item_index]
	
	func add_item(item : Item):
		if (item in _items):
			return
		
		_items.append(item)
		_current_item_index = _items.size() - 1
		emit_signal("changed")
		
	func remove_item(item : Item):
		var index := _items.find(item)
		if (index == -1):
			return
		
		_items.remove(index)
		if (_current_item_index >= _items.size()):
			_current_item_index = 0 if _items else -1
		emit_signal("changed")
		
	func select_next():
		if (_current_item_index == -1):
			return
		_current_item_index = (_current_item_index + 1) % _items.size()
		emit_signal("changed")
	
	func select_prev():
		if (_current_item_index == -1):
			return
		_current_item_index = (_current_item_index + 1 + _items.size()) % _items.size()
		emit_signal("changed")
	
	func to_dict():
		var names := []
		for item in _items:
			var path := item.resource_path as String
			names.append(path.get_file().get_basename())
		return {
			items = names,
			current_item_index = _current_item_index
		}
		
	func from_dict(dict: Dictionary):
		_current_item_index = dict.current_item_index
		_items.clear()
		for name in dict.items:
			_items.append(load("res://Island/Items/%s.tres" % name))
		emit_signal("changed")
		
	func reset():
		_current_item_index = -1
		_items.clear()
		emit_signal("changed")

var flags := Flags.new()
var inventory := Inventory.new()


func save_game():
	var file = File.new()
	if (file.open(SAVE_PATH, File.WRITE) != OK):
		return
	var data := {
		inventory = inventory.to_dict(),
		flags = flags.to_dict(),
		current_scene = get_tree().current_scene.filename.get_file().get_basename(),
	}
	var json := to_json(data)
	file.store_string(json)


func load_game():
	var file = File.new()
	if (file.open(SAVE_PATH, File.READ) != OK):
		return
	var json = file.get_as_text()
	var data := parse_json(json) as Dictionary
	inventory.from_dict(data.inventory)
	flags.from_dict(data.flags)
	scene_changer.change_scene("res://Island/Scenes/%s.tscn" % data.current_scene)


func new_game():
	inventory.reset()
	flags.reset()
	scene_changer.change_scene("res://Island/Scenes/H1.tscn")


func has_save_file() -> bool:
	return File.new().file_exists(SAVE_PATH)

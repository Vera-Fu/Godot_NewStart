tool
extends Node2D

const SLOT_TEXTURE := preload("res://Island/Assets/H2A/CIRCLE.png")
const LINE_TEXTURE := preload("res://Island/Assets/H2A/CIRCLELINE.png")

export var radius := 100.0 setget set_radius
export var config : Resource setget set_config

var _stone_map := {}

func _draw():
	for slot in H2AConfig.Slot.size():
		draw_texture(SLOT_TEXTURE, _get_slot_position(slot) - SLOT_TEXTURE.get_size() / 2)


func set_radius(v: float):
	radius = v
	update()


func set_config(v: H2AConfig):
	if (config && config.is_connected("changed", self, "_update_board")):
		config.disconnect("changed", self, "_update_board")
	config = v
	if (config && !config.is_connected("changed", self, "_update_board")):
		config.connect("changed", self, "_update_board")
	_update_board()


func reset():
	for s in _stone_map.values():
		_move_stone(s, config.placements[s.target_slot])


func _get_slot_position(slot: int) -> Vector2:
	return Vector2.DOWN.rotated(TAU / H2AConfig.Slot.size() * slot) * radius


func _update_board():
	for node in get_children():
		if (node.owner == null):
			node.queue_free()
		
	if (!config):
		return
	
	for src in H2AConfig.Slot.size():
		for dst in range(src + 1, H2AConfig.Slot.size()):
			if (!(dst in config.connections[src])):
				continue
			var line := Line2D.new()
			add_child(line)
			line.add_point(_get_slot_position(src))
			line.add_point(_get_slot_position(dst))
			line.width = LINE_TEXTURE.get_size().y
			line.texture = LINE_TEXTURE
			line.texture_mode = Line2D.LINE_TEXTURE_TILE
			line.default_color = Color.white
			line.show_behind_parent = true
			
	for slot in range(1, H2AConfig.Slot.size()):
		var stone := H2AStone.new()
		add_child(stone)
		stone.target_slot = slot
		stone.current_slot = config.placements[slot]
		stone.position = _get_slot_position(stone.current_slot)
		_stone_map[slot] = stone
		stone.connect("interact", self, "_request_move", [stone])


func _request_move(stone: H2AStone):
	var available := H2AConfig.Slot.values()
	for s in _stone_map.values():
		available.erase(s.current_slot)
	assert(available.size() == 1)
	var available_slot = available.front() as int
	if (available_slot in config.connections[stone.current_slot]):
		_move_stone(stone, available_slot)


func _move_stone(stone: H2AStone, slot: int):
	stone.current_slot = slot
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(stone, "position", _get_slot_position(slot), 0.2)
	tween.tween_interval(1.0)
	tween.tween_callback(self, "_check")


func _check():
	for s in _stone_map.values():
		if (s.current_slot != s.target_slot):
			return
	
	Game.flags.add("h2a_unlocked")
	scene_changer.change_scene("res://Island/Scenes/H2.tscn")

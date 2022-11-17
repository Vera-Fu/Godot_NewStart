tool
extends Area2D

class_name Interactable

signal interact

export var texture : Texture setget set_texture
export var allow_item := false

func _input_event(viewport, event, shape_idx):
	if !event.is_action_pressed("interact"):
		return
	if (!allow_item && Game.inventory.active_item):
		return
		
	_interact()
	
func _interact():
	emit_signal("interact")


func set_texture(v: Texture):
	texture = v

	for node in get_children():
		if (node.owner == null):
			node.queue_free()

	if (texture == null):
		return

	var sprite := Sprite.new()
	sprite.texture = texture
	add_child(sprite)

	var rect := RectangleShape2D.new()
	rect.extents = v.get_size() / 2

	var collider := CollisionShape2D.new()
	collider.shape = rect
	add_child(collider)

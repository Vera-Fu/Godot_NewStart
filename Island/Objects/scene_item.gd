tool
extends Interactable
class_name SceneItem

export var item : Resource setget set_item


func _ready():
	if (Engine.editor_hint):
		return
		
	if (Game.flags.has(_get_flag())):
		queue_free()


func set_item(v: Item):
	item = v
	set_texture(item.scene_texture if item else null)
	property_list_changed_notify()
	

func _interact():
	._interact()
	
	Game.flags.add(_get_flag())
	Game.inventory.add_item(item)
	
	var sprite := Sprite.new()
	sprite.texture = item.scene_texture
	get_parent().add_child(sprite)
	sprite.global_position = global_position
	
	var tween := sprite.create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite,"scale",Vector2.ZERO,0.3)
	tween.tween_callback(sprite, "queue_free")
#	yield(tween,"finished")
#	print("hello")
	queue_free()


func _get_flag():
	return "picked" + item.resource_path.get_file()

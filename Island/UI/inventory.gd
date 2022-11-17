extends VBoxContainer

onready var description = $Description
onready var prev = $HBoxContainer/Prev
onready var prop = $HBoxContainer/Use/Prop
onready var hand = $HBoxContainer/Use/Hand
onready var next = $HBoxContainer/Next
onready var timer = $Description/Timer

var _hand_outro : SceneTreeTween
var _description_outro : SceneTreeTween
var x

func _ready():
	Game.inventory.connect("changed", self, "_update_ui")
	_update_ui(true)
	
	hand.hide()
	hand.modulate.a = 0.0
	description.hide()
	description.modulate.a = 0.0

func _input(event):
	if (event.is_action_pressed("interact") && Game.inventory.active_item):		
		Game.inventory.set_deferred("active_item", null)
		
		_hand_outro = create_tween()
		_hand_outro.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_parallel()
		_hand_outro.tween_property(hand, "scale", Vector2.ONE * 3, 0.15)
		_hand_outro.tween_property(hand, "modulate:a", 0.0, 0.15)
		_hand_outro.chain().tween_callback(hand, "hide")
	


func _update_ui(is_init := false):
	var count = Game.inventory.get_item_count()
	prev.disabled = count < 2
	next.disabled = count < 2
	visible = count > 0
	
	var item := Game.inventory.get_current_item()
	if (!item):
		return
	
	description.text = item.description
	prop.texture = item.prop_texture
	
	if (is_init):
		return
		
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(prop,"scale",Vector2.ONE,0.15).from(Vector2.ZERO)
	_show_description()


func _show_description():
	if (_description_outro && _description_outro.is_valid()):
		_description_outro.kill()
		_description_outro = null
	
	description.show()
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(description, "modulate:a", 1.0, 0.2)	
	tween.tween_callback(timer, "start")


func _on_Prev_pressed():
	Game.inventory.select_prev()


func _on_Next_pressed():
	Game.inventory.select_next()


func _on_Use_pressed():
	Game.inventory.active_item = Game.inventory.get_current_item()	
	if (_hand_outro && _hand_outro.is_valid()):
		_hand_outro.kill()
		_hand_outro = null
		
	hand.show()
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel()
	tween.tween_property(hand, "scale", Vector2.ONE, 0.15).from(Vector2.ZERO)
	tween.tween_property(hand, "modulate:a", 1.0, 0.15)	
	
	_show_description()


func _on_Timer_timeout():
	_description_outro = create_tween()
	_description_outro.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	_description_outro.tween_property(description, "modulate:a", 0.0, 0.2)
	_description_outro.tween_callback(description, "hide")

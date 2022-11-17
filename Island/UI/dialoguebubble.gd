extends Control

var _dialogues := []
var _current_line := -1

onready var content = $Content


func _ready():
	hide()
	
	
func show_dialogue(dialogues : Array):
	if (_current_line == -1) || (_dialogues != dialogues):
		_dialogues = dialogues
		_show_line(0)
		show()
	else:
		_advance()


func _show_line(line : int):
	_current_line = line
	content.text = _dialogues[_current_line]
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "rect_scale", Vector2.ONE, 0.2).from(Vector2.ZERO)


func _advance():
	if (_current_line + 1 < _dialogues.size()):
		_show_line(_current_line + 1)
	else:
		_current_line = -1
		hide()


func _on_Content_gui_input(event):
	if (event.is_action_pressed("interact")):
		_advance()

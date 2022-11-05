extends Line2D

onready var icon = get_parent().get_node("Icon")
var icon_position : Vector2
#
func _ready():
	add_point(Vector2(100.0, 200.0))
	add_point(Vector2(200.0, 200.0))

func _process(delta):
	icon_position = icon.position
	
	
func _physics_process(delta):
	add_point(icon_position)
	if (get_point_count() >= 20):
		remove_point(0)

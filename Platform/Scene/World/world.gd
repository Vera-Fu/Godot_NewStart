extends Node2D


func _ready():
	var tilemap = $TileMap
	var rect = tilemap.get_used_rect()
	var bounds = Rect2(
		rect.position.x * tilemap.cell_size.x,
		rect.position.y * tilemap.cell_size.y,
		rect.size.x * tilemap.cell_size.x,
		rect.size.y * tilemap.cell_size.y		
	)
	
	var camera = $Player/Camera2D
#	camera.limit_top = bounds.position.y
	camera.limit_bottom = bounds.end.y
	camera.limit_left = bounds.position.x
	camera.limit_right = bounds.end.x
	
	camera.force_update_scroll()
	camera.reset_smoothing()
	
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(bounds.size.x / 2, tilemap.cell_size.y / 2)
	$HitBox/CollisionShape2D.shape = shape
	$HitBox.position = Vector2(
		bounds.position.x + bounds.size.x / 2,
		bounds.end.y + tilemap.cell_size.y * 2
	)
	
	add_child(preload("res://Platform/Scene/UI/HUD.tscn").instance())


func _input(event):
	pass

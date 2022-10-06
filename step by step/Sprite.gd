extends Sprite

signal health_depleted

var HP = 5

var speed = 400
var angular_speed = PI

func _ready():
	var timer = get_node("Timer")
	timer.connect("timeout", self, "_on_Timer_timeout")

func _process(delta):
	
	### 自动移动
	rotation += angular_speed * delta
	var velocity = Vector2.UP.rotated(rotation) * speed
	position += velocity * delta
	
	
	### 用户输入操控移动
#	var direction = 0
#	if Input.is_action_pressed("ui_left"):
#		direction = -1
#	if Input.is_action_pressed("ui_right"):
#		direction = 1
#
#	rotation += angular_speed * direction * delta
#
#	var velocity = Vector2.ZERO
#	if Input.is_action_pressed("ui_up"):
#		velocity = Vector2.UP.rotated(rotation) * speed
#
#	position += velocity * delta


func _on_Button_pressed():
	set_process(not is_processing()) # Replace with function body.

func _on_Timer_timeout():
	take_damage(1)
	
func take_damage(amount):
	print("HP:", HP)	
	if HP <= 0:
		emit_signal("health_depleted")
	else:
		HP -= amount

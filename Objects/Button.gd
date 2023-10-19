extends StaticBody2D

var pressed = false
var can_press = false

func _ready():
	# Set the initial state of the door (closed).
	unpress()

func _process(_delta):
	if Input.is_action_just_pressed("interact") and can_press: 
		if pressed: 
			unpress()
		else:
			press()

func press():
	pressed = true
	$ButtonArea/NotPressed.hide()
	$ButtonArea/Pressed.show()

func unpress():
	pressed = false
	$ButtonArea/Pressed.hide()
	$ButtonArea/NotPressed.show()

func _on_ButtonArea_body_entered(body):
	if body.has_method("player"):
		can_press = true


func _on_ButtonArea_body_exited(body):
	if body.has_method("player"):
		can_press = false

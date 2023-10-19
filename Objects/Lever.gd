extends StaticBody2D

var switched = false
var can_switch = false

func _ready():
	# Set the initial state of the door (closed).
	unswitch()

func _process(_delta):
	if Input.is_action_just_pressed("interact") and can_switch: 
		if switched: 
			unswitch()
		else:
			switch()

func switch():
	switched = true
	$LeverArea/NotSwitched.hide()
	$LeverArea/Switched.show()

func unswitch():
	switched = false
	$LeverArea/Switched.hide()
	$LeverArea/NotSwitched.show()

func _on_LeverArea_body_entered(body):
	if body.has_method("player"):
		can_switch = true


func _on_LeverArea_body_exited(body):
	if body.has_method("player"):
		can_switch = false

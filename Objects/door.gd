extends StaticBody2D

var is_open = false
var can_open = false

func _ready():
	# Set the initial state of the door (closed).
	close_door()

func _process(_delta):
	pass
	#if Input.is_action_just_pressed("interact") and can_open: 
	#	if is_open: 
	#		close_door()
	#	else:
	#		open_door()

func open_door():
	is_open = true
	$CollisionClosed.disabled = true
	$DoorArea/Closed.hide()
	$DoorArea/Opened.show()

func close_door():
	is_open = false
	$CollisionClosed.disabled = false
	$DoorArea/Opened.hide()
	$DoorArea/Closed.show()

func _on_DoorArea_body_entered(body):
	if body.has_method("player"):
		can_open = true


func _on_DoorArea_body_exited(body):
	if body.has_method("player"):
		can_open = false

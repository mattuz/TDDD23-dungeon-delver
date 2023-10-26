extends StaticBody2D

var is_open = false
var can_open = false
var has_closed = false

func _ready():
	# Set the initial state of the door (closed).
	close_door()
	#open_door()

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
	$winSound.play()
	$doorOpen.play()
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
	if body.has_method("boss"):
		print("boss in room")


func _on_DoorArea_body_exited(body):
	if body.has_method("boss"):
		#open_door()
		pass
	if body.has_method("player"):
		#close_door()
		pass

func bossdoor():
	pass

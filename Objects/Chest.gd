extends StaticBody2D

var is_open = false
var can_open = false
var angel 


func _ready():
	angel = $Angel2
	angel.current_message = angel.current_message + 1
	$Angel2/Chatbox.show_message(angel.chat_messages[angel.current_message])

	# Set the initial state of the door (closed).
	close()

func _process(_delta):
	if Input.is_action_just_pressed("interact") and can_open: 
		if is_open: 
			close()
		else:
			open()

func open():
	is_open = true
	$ChestArea/Closed.hide()
	$ChestArea/Opened.show()

func close():
	is_open = false
	$ChestArea/Opened.hide()
	$ChestArea/Closed.show()


func _on_ChestArea_body_entered(body):
	if body.has_method("player"):
		can_open = true


func _on_ChestArea_body_exited(body):
	if body.has_method("player"):
		can_open = false

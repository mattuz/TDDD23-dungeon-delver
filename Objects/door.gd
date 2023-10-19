extends Area2D

var is_open = false
var can_open = false

func _ready():
	# Set the initial state of the door (closed).
	close_door()

func _process(_delta):
	if Input.get_action_strength("interact") == 1: 
		#$bow.visible = true
		if is_open: #need this to happen only once. 
			close_door()
		else:
			open_door()
		#print("E pressed")

func open_door():
	is_open = true
	$Closed.hide()
	$Opened.show()

func close_door():
	is_open = false
	$Opened.hide()
	$Closed.show()


#func _on_Door_input_event(viewport, event, shape_idx):
#	#if evet is InputEventKey and event.
#	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed and can_open:
#			print("clicked")
#			if is_open:
#				close_door()
#			else:
#				open_door()


func _on_Door_body_entered(body):
	if body.has_method("player"):
		can_open = true
		print("can open")
	#if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
	#	print("clicked")
	#	if is_open:
	#		close_door()
	#	else:
	#		open_door()


func _on_Door_body_exited(body):
	if body.has_method("player"):
		print("can't open")
		can_open = false
	pass # Replace with function body.

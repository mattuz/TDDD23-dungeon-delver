extends StaticBody2D

var is_open = false
var can_open = false
var has_closed = false
var can_close = false

func _ready():
	open_door()
	$doorOpen.volume_db = -100

func _process(_delta):
	#pass
	if Input.get_action_strength("up") > 0 or Input.get_action_strength("down") > 0 or Input.get_action_strength("left") > 0 or Input.get_action_strength("right") > 0:
		if can_close: 
			can_close = false
			close_door()
		if can_open:
			can_open = false
			open_door()


func open_door():
	is_open = true
	$CollisionClosed.disabled = true
	$doorOpen.volume_db = 0
	$DoorArea/Closed.hide()
	$DoorArea/Opened.show()

func close_door():
	is_open = false
	$CollisionClosed.disabled = false
	$DoorArea/Opened.hide()
	$DoorArea/Closed.show()

func _on_DoorArea_body_entered(body):
	if body.has_method("player") and not has_closed:
		can_close = true
		has_closed = true


func _on_DoorArea_body_exited(body):
	if body.has_method("boss"):
		$doorOpen.play()
		open_door()
		pass
	if body.has_method("player"):
		#close_door()
		pass


func _on_openArea_body_exited(body):
	if body.has_method("player"):
		#open_door()
		can_open = true
		is_open = true
		can_close = false
		has_closed = false

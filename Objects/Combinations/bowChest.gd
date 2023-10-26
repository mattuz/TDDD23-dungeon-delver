extends StaticBody2D

var is_open = false
var can_open = false
var angel 
const potPath = preload('res://Objects/bow_power.tscn')
var item_out = false


func _ready():
	#angel = $Angel2
	#angel.current_message = angel.current_message + 1
	#$Angel2/Chatbox.show_message(angel.chat_messages[angel.current_message])

	# Set the initial state of the door (closed).
	close()

func _process(_delta):
	if Input.is_action_just_pressed("interact") and can_open: 
		if is_open: 
			close()
		else:
			open()

func open():
	if not item_out:
		$Label.show()
		print("pop it out!!")
		item_out = true
		$Sprite.visible = true
		$Sprite.texture = preload('res://.import/weapon_bow.png-70cdb2b14beb9871c8f26be6be617b44.stex')
		$AnimationPlayer.play("popout")
		$ItemTimer.start()
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


func _on_ItemTimer_timeout():
	print("timeout!!")
	$Sprite.visible = false
	var pot = potPath.instance()
	get_parent().add_child(pot)
	pot.position = $Sprite.global_position


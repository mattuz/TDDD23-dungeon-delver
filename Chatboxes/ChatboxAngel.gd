extends Control

var label

func _ready():
	label = $Label
	hide()

func show_message(message):
	print("Message should be: ",message)
	label.text = message
	show()

func hide_message():
	hide()

func _input(event):
	if event.is_action_pressed("interact"):
		print("test")
		hide_message()

extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	if $Lever.switched and not $Door.is_open:
		$Door.open_door()
	else:
		pass
		#$Door.close_door()
	pass

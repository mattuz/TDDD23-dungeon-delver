extends Area2D


var spawned = false
const angelPath = preload('res://Characters/Angel.tscn')


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_angelTrigger_body_entered(body):
	if body.has_method("player"):
		print("player detected")
		if not spawned:
			var angel = angelPath.instance()
			get_parent().add_child(angel)
			angel.current_message = 1
			angel.position = Vector2(1096, -1192)
			angel.show_message()
			spawned = true
			
			#1096, -1192
	pass # Replace with function body.


func _on_angelTrigger_body_exited(body):
	pass # Replace with function body.

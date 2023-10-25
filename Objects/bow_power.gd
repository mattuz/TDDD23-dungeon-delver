extends Area2D

func _ready():
	pass # Replace with function body.
	
func _on_bow_power_body_entered(body):
	if body.has_method("player"):
		print("should have power")	
		body.get_node("Cooldown").wait_time = body.get_node("Cooldown").wait_time - .25
		queue_free()


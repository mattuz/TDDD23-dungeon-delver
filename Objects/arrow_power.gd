extends Area2D

func _ready():
	pass # Replace with function body.

func _on_arrow_power_body_entered(body):
	if body.has_method("player"):
		body.set_arrow_dmg(body.arrow_damage+1)
		queue_free()

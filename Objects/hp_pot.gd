extends Area2D

func _ready():
	pass # Replace with function body.

func _on_hp_pot_body_entered(body):
	if body.has_method("player"):
		body.health = 6
		body.display_hp(body.health)
		print(body.health)
		queue_free()

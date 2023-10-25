extends Area2D

var entered = false



func _ready():
	pass # Replace with function body.


func _on_checkpoint_body_entered(body):
	if body.has_method("player"):
		if not entered:
			GameManager.set_player_checkpoint(position)
			print("checkpoint set!")
			#entered = true

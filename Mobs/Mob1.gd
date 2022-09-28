extends RigidBody2D


func _ready():
	$AnimatedSprite.playing = true
	$AnimatedSprite.play("IDLE")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

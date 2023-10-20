extends KinematicBody2D

var speed = 200


func _ready():
	$AnimatedSprite.playing = true
	$AnimatedSprite.play("IDLE")


func _process(delta):
	if GameManager.player_position.x > position.x:
		$AnimatedSprite.play("IDLE")
		$AnimatedSprite.flip_h = 0
	else:
		$AnimatedSprite.play("IDLE")
		$AnimatedSprite.flip_h = 1

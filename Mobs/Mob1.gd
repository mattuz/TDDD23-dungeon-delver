extends RigidBody2D

var health = 1

func _ready():
	$AnimatedSprite.playing = true
	$AnimatedSprite.play("IDLE")

func take_damage(damage):
	$Timer.start()
	flash()
	health -= damage

	if health <= 0:
		die()

func die():
	#game over/restart from checkpoint
	print("dead")
	
func flash():
	$AnimatedSprite.modulate = Color(1,1,1,0.5)
	$AnimatedSprite.modulate = Color(255,255,255)

func reset_flash():
	$AnimatedSprite.modulate = Color(1, 1, 1, 1)  # Reset the sprite's color
	#$Sprite.texture = preload("res://original_texture.png")  # Set the original texture
func _on_Timer_timeout():
	reset_flash()  # Reset the sprite to its original appearance


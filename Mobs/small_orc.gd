extends KinematicBody2D
var health = 3
var particle_system

func _ready():
	$AnimatedSprite.playing = true
	$AnimatedSprite.play("IDLE")
	particle_system = $Particles2D


func take_damage(damage):
	$DamageTimer.start()
	flash()
	health -= damage
	if health <= 0:
		die()

func die():
	$DespawnTimer.start()
	$AnimatedSprite.hide()
	particle_system.emitting = true  # Trigger the particle system
	print("dead")

func flash():
	$AnimatedSprite.modulate = Color(1,1,1,0.5)
	$AnimatedSprite.modulate = Color(255,255,255)

func reset_flash():
	$AnimatedSprite.modulate = Color(1, 1, 1, 1)  # Reset the sprite's color
	#$Sprite.texture = preload("res://original_texture.png")  # Set the original texture
func _on_DamageTimer_timeout():
	reset_flash()  # Reset the sprite to its original appearance
func _on_DespawnTimer_timeout():
	queue_free()


extends KinematicBody2D
var health = 3
var particle_system
var speed = 30
var patrol_size = 20
var starting_pos = position

var patrol_position = Vector2()
var next_patrol_direction = Vector2()
var is_patrolling


func _ready():
	$AnimatedSprite.playing = true
	$AnimatedSprite.play("IDLE")
	particle_system = $Particles2D
	#patrol_position = position + Vector2(rand_range(-patrol_size, patrol_size),
	#									 rand_range(-patrol_size, patrol_size))
	next_patrol_direction = (patrol_position - position).normalized()
	print(position)
	
	set_patrol_position()
	is_patrolling = true

func _physics_process(delta):
	if is_patrolling:
		#print("is patrolling")
		patrol()
	else:
		pursue_player()

func patrol():
	if position.distance_to(patrol_position) < 5:
		set_patrol_position()
		next_patrol_direction = (patrol_position - position).normalized()
		print(position)

	var velocity = next_patrol_direction * speed
	#print(velocity)
	move_and_slide(velocity)

func set_patrol_position():
	var new_patrol_position = position + Vector2(rand_range(-patrol_size, patrol_size), rand_range(-patrol_size, patrol_size))
	while new_patrol_position.distance_to(position) > patrol_size:
		new_patrol_position = position + Vector2(rand_range(-patrol_size, patrol_size), rand_range(-patrol_size, patrol_size))
	patrol_position = new_patrol_position

func pursue_player():
	is_patrolling = false
	#var player_position = player.position
	#var direction_to_player = (player_position - position).normalized()
	#var velocity = direction_to_player * speed
	#move_and_slide(velocity)

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


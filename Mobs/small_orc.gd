extends KinematicBody2D
var health = 3
var particle_system
var speed = 50
var damage_range = 10

var starting_pos
var patrol_area
var patrol_position = Vector2()
var next_patrol_direction = Vector2()
var patrol_size = 150
var half_patrol_size = patrol_size/2

var is_patrolling
var patrol_wait = false
var detection_range = 100
var chase_player = false


func _ready():
	$AnimatedSprite.playing = true
	$AnimatedSprite.play("IDLE")
	particle_system = $Particles2D
	starting_pos = position
	patrol_area = Rect2(Vector2(position.x-half_patrol_size, position.y-half_patrol_size),
						Vector2(patrol_size, patrol_size))
	patrol_position = get_random_position_in_patrol_area()
	next_patrol_direction = (patrol_position - position).normalized()
	is_patrolling = true
	

func _physics_process(delta):
	if is_patrolling:	
		is_patrolling = not is_player_in_vicinity()
		patrol()
	else:
		pursue_player()

################################Movement#####################################
func patrol():
	if position.distance_to(patrol_position) < 2:
		print("timer started")
		$PatrolTimer.start()
		patrol_wait = true
		patrol_position = get_random_position_in_patrol_area()
		next_patrol_direction = (patrol_position - position).normalized()
		

	var velocity = next_patrol_direction * speed
	if not patrol_wait:
		move_and_slide(velocity)

func get_random_position_in_patrol_area():
	var rand_x = rand_range(patrol_area.position.x, patrol_area.position.x + patrol_area.size.x)
	var rand_y = rand_range(patrol_area.position.y, patrol_area.position.y + patrol_area.size.y)
	return Vector2(rand_x, rand_y)

func is_player_in_vicinity():
	if position.distance_to(GameManager.get_player_position()) <= detection_range:
		return true
	else:
		return false

func pursue_player():
	is_patrolling = false
	var player_position = GameManager.get_player_position()
	var direction_to_player = (player_position - position).normalized()
	var velocity = direction_to_player * speed
	move_and_slide(velocity)
######################################################

###########################Damage##############################
func deal_damage():
	
	
	pass

func can_damage_player():
	
	pass
	
func take_damage(damage):
	is_patrolling = false
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
##############################################

##################################Listeners#################################
func _on_DamageTimer_timeout():
	reset_flash()  # Reset the sprite to its original appearance
func _on_DespawnTimer_timeout():
	queue_free()
func _on_PatrolTimer_timeout():
	print("ding")
	patrol_wait = false
	


extends KinematicBody2D
var health = 5
var starting_health
var particle_system
var speed = 50
var can_attack = true
var can_charge = true
var charging = false
var moving
var combat = false
var afk = true

var starting_pos
var patrol_area
var patrol_position = Vector2()
var next_patrol_direction = Vector2()
var patrol_size = 120
var half_patrol_size = patrol_size/2

var is_patrolling
var patrol_wait = false
var detection_range = 160
var chase_player = false
var charge_pos = Vector2()


func _ready():
	starting_health=health
	$AnimatedSprite.playing = true
	$AnimatedSprite.play("IDLE")
	particle_system = $Particles2D
	starting_pos = position
	patrol_area = Rect2(Vector2(position.x-half_patrol_size, position.y-half_patrol_size),
						Vector2(patrol_size, patrol_size))
	patrol_position = get_random_position_in_patrol_area()
	next_patrol_direction = (patrol_position - position).normalized()
	is_patrolling = true
	moving = false
	

func reset():
	position = starting_pos
	is_patrolling = true
	moving = false
	chase_player = false
	health = starting_health

func _physics_process(delta):
	if not afk:
		if is_patrolling:	
			if moving == true:
				if patrol_position.x > position.x:
					$AnimatedSprite.play("WALK")
					$AnimatedSprite.flip_h = 0
					
				else:
					$AnimatedSprite.play("WALK")
					$AnimatedSprite.flip_h = 1
			else: 
				$AnimatedSprite.play("IDLE")
			is_patrolling = not is_player_in_vicinity()
			patrol()
		else:
			if moving == true:
				if GameManager.player_position.x > position.x:
					$AnimatedSprite.play("WALK")
					$AnimatedSprite.flip_h = 0
					
				else:
					$AnimatedSprite.play("WALK")
					$AnimatedSprite.flip_h = 1
			else: 
				$AnimatedSprite.play("IDLE")
				
			charge()
			#pursue_player()


################################Movement#####################################
func patrol():
	if position.distance_to(patrol_position) < 2:
		moving = false
		$PatrolTimer.start()
		patrol_wait = true
		patrol_position = get_random_position_in_patrol_area()
		next_patrol_direction = (patrol_position - position).normalized()
		
	moving = false
	var velocity = next_patrol_direction * speed
	if not patrol_wait:
		moving = true
		move_and_slide(velocity)

func get_random_position_in_patrol_area():
	var rand_x = rand_range(patrol_area.position.x, patrol_area.position.x + patrol_area.size.x)
	var rand_y = rand_range(patrol_area.position.y, patrol_area.position.y + patrol_area.size.y)
	return Vector2(rand_x, rand_y)

func is_player_in_vicinity():
	if position.distance_to(GameManager.get_player_position()) <= detection_range:
		charge_pos = GameManager.get_player_position()
		print(charge_pos)
		return true
	else:
		return false

func pursue_player():
	moving = true
	is_patrolling = false
	#var player_position = GameManager.get_player_position()
	#var direction_to_player = (player_position - position).normalized()
	#var velocity = direction_to_player * speed
	if not can_attack:
		#move_and_slide(-(direction_to_player)*(speed/4))
		pass
	else:
		#move_and_slide(velocity)
		move_and_slide((charge_pos-position).normalized()*speed)
######################################################

###########################Damage##############################
func deal_damage():
	if can_attack:
		$Node2D.look_at(GameManager.get_player_position()) #now "targets" player
		$Node2D/Position2D/Testattack.visible = true
		$SliceTimer.start()
		can_attack = false
		print("dealing damage chort")
		$AttackCooldown.start()
		
		return 1 #amount of damage

	return 0
	
func charge():
	if can_charge:
		charge_pos = GameManager.get_player_position()
		charging = true
		can_charge = false
		$ChargeCooldown.start()
		$ChargingTimer.start()
	
	if charging:
		var charge_speed = 200
		var direction_to_player = (charge_pos - position).normalized()
		moving = true
		if position.distance_to(charge_pos) < 2:
			moving = false
		else:
			move_and_slide(direction_to_player*charge_speed)

func take_damage(damage):
	is_patrolling = false
	$DamageTimer.start()
	flash()
	health -= damage
	if health <= 0:
		die()

func die():
	$DeathSound.play()
	get_node("CollisionShape2D").disabled = true
	$DespawnTimer.start()
	$AnimatedSprite.hide()
	particle_system.emitting = true  # Trigger the particle system

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
	patrol_wait = false
func _on_AttackCooldown_timeout():
	can_attack = true
	
func enemy():
	pass


func _on_SliceTimer_timeout():
	$Node2D/Position2D/Testattack.visible = false


func _on_CollisionArea_body_entered(body):
	if is_patrolling:
		if body.has_method("environment") or body.has_method("enemy") and body != self:
			moving = false
			$PatrolTimer.start()
			patrol_wait = true
			patrol_position = starting_pos
			next_patrol_direction = (patrol_position - position).normalized()
			patrol()

func _on_CollisionArea_body_exited(body):
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_entered():
	afk = false


func _on_ChargeCooldown_timeout():
	print("can_charge reset")
	can_charge = true


func _on_ChargingTimer_timeout():
	print("charging reset")
	charging = false

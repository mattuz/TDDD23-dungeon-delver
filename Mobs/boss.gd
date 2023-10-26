extends KinematicBody2D
var health = 100
var starting_health
var particle_system
var speed = 50
var can_attack = true
var can_shoot = true
var moving
var combat = false
var afk = true
var spawn1 = false
var spawn2 = false
var spawn3 = false


const fireballPath = preload('res://items/Fireball.tscn')
const shamanPath = preload('res://Mobs/orcs/orc_shaman.tscn')
const chortPath = preload('res://Mobs/demons/chort.tscn')

var can_charge = true
var charging = false
var charge_up = false

var starting_pos
var patrol_area
var patrol_position = Vector2()
var next_patrol_direction = Vector2()
var patrol_size = 120
var half_patrol_size = patrol_size/2

var is_patrolling
var patrol_wait = false
var detection_range = 200
var shooting_range_x = 240
var shooting_range_y = 140
var chase_player = false
var charge_pos = Vector2()


func _ready():
	starting_health = health
	$HPbar/Control/ProgressBar.value = health
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
	$HPbar/Control/ProgressBar.value = health
	spawn1 = false
	spawn2 = false
	spawn3 = false
	$ChargeCooldown.wait_time = 5
	$FireballCooldown.wait_time = 2
	

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
			shoot()
			charge()
			if not charge_up:
				moving = true
				pursue_player()
			if health <= 75:
				$ChargeCooldown.wait_time = 3
				$FireballCooldown.wait_time = 1.5
				if not spawn1:
					$hp75.play()
					spawn_chorts(1)
					spawn_shamans(1)
					spawn1 = true
					pass
			if health <= 50:
				$FireballCooldown.wait_time = 1
				if not spawn2:
					$hp50.play()
					spawn2 = true
					#spawn_chorts(1)
					spawn_shamans(4)
					pass
			if health <= 25:
				$ChargeCooldown.wait_time = 1.5
				$FireballCooldown.wait_time = .3
				if not spawn3:
					$hp25.play()
					spawn3 = true
					spawn_chorts(2)
					spawn_shamans(4)
					pass
				


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
	#	move_and_slide(next_patrol_direction * speed)
		move_and_slide(velocity)

func get_random_position_in_patrol_area():
	var rand_x = rand_range(patrol_area.position.x, patrol_area.position.x + patrol_area.size.x)
	var rand_y = rand_range(patrol_area.position.y, patrol_area.position.y + patrol_area.size.y)
	return Vector2(rand_x, rand_y)

func is_player_in_vicinity():
	if position.distance_to(GameManager.get_player_position()) <= detection_range:
		GameManager.in_combat = true
		return true
	else:
		return false

func pursue_player():
	moving = true
	is_patrolling = false

	var player_position = GameManager.get_player_position()
	var direction_to_player = (player_position - position).normalized()
	var velocity = direction_to_player * speed

	move_and_slide(velocity)
######################################################

###########################Damage##############################
func shoot():
	if can_shoot:
		var distance_x = abs(GameManager.get_player_position().x - position.x)
		var distance_y =  abs(GameManager.get_player_position().y - position.y)
		$Node2D.look_at(GameManager.get_player_position())
		if distance_x <= shooting_range_x and distance_y <= shooting_range_y:
			$FireballSound.play()
			can_shoot = false
			$FireballCooldown.start()
			var fireball = fireballPath.instance()
			get_parent().add_child(fireball)
			fireball.position = $Node2D/Position2D.global_position
			fireball.velocity = GameManager.get_player_position() - fireball.position

func deal_damage():
	if can_attack:
		$Node2D.look_at(GameManager.get_player_position()) #now "targets" player
		$Node2D/Position2D/Testattack.visible = true
		$SliceTimer.start()
		can_attack = false
		$AttackCooldown.start()
		
		return 1 #amount of damage

	return 0

func charge():
	$AnimatedSprite.playing = true
	if can_charge:
		charge_pos = GameManager.get_player_position()
		can_charge = false
		charge_up = true

	elif charge_up:
		$AnimatedSprite.play("CHARGE_POWER")
		if not health <= 50:
			can_shoot = false
		if $PowerUpTimer.time_left>0:
			if GameManager.player_position.x > position.x:
				$AnimatedSprite.play("CHARGE_POWER")
				$AnimatedSprite.flip_h = 0
			else:
				$AnimatedSprite.play("CHARGE_POWER")
				$AnimatedSprite.flip_h = 1
		else:
			$PowerUpTimer.start()
	
	elif charging:
		var charge_speed = 250
		var direction_to_player = (charge_pos - position).normalized()
		moving = true
		if position.distance_to(charge_pos) < 2:
			can_shoot = true
			charging = false
			moving = false
		else:
			move_and_slide(direction_to_player*charge_speed)

func take_damage(damage):
	is_patrolling = false
	$DamageTimer.start()
	flash()
	health -= damage
	$HPbar/Control/ProgressBar.value = health
	if health <= 0:
		die()

func die():
	GameManager.in_combat = false
	$DeathSound.play()
	get_node("CollisionShape2D").disabled = true
	$DespawnTimer.start()
	$AnimatedSprite.hide()
	particle_system.emitting = true  # Trigger the particle system
	$winSound.play()

func flash():
	$AnimatedSprite.modulate = Color(1,1,1,0.5)
	$AnimatedSprite.modulate = Color(255,255,255)

func reset_flash():
	$AnimatedSprite.modulate = Color(1, 1, 1, 1)  # Reset the sprite's color
	#$Sprite.texture = preload("res://original_texture.png")  # Set the original texture	
##############################################

func spawn_chorts(amount):
	for i in range(amount):
		var chort = chortPath.instance()
		get_parent().add_child(chort)
		if i == 0:
			chort.position = Vector2(global_position.x +20, global_position.y+40)
		elif i == 1:
			chort.position = Vector2(global_position.x -20, global_position.y-40)
		elif i == 2:
			chort.position = Vector2(global_position.x -20, global_position.y+40)
		else:
			chort.position = Vector2(global_position.x +20, global_position.y-40)
		


func spawn_shamans(amount):
	for i in range(amount):
		var shaman = shamanPath.instance()
		get_parent().add_child(shaman)
		if i == 0:
			shaman.position = Vector2(global_position.x +40, global_position.y+40)
		elif i == 1:
			shaman.position = Vector2(global_position.x -40, global_position.y-40)
		elif i == 2:
			shaman.position = Vector2(global_position.x -40, global_position.y+40)
		else:
			shaman.position = Vector2(global_position.x +40, global_position.y-40)
			
		
		


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
	can_charge = true


func _on_ChargingTimer_timeout():
	charging = false


func boss():
	pass


func _on_DoorArea_body_entered(body):
	if body.has_method("open_door"):
		#print("door door")
		pass
	pass # Replace with function body.


func _on_DoorArea_body_exited(body):
	if body.has_method("open_door"):
		body.open_door()
	pass # Replace with function body.


func _on_PowerUpTimer_timeout():
	charge_pos = GameManager.get_player_position()
	charge_up = false
	$ChargeCooldown.start()
	$ChargingTimer.start()
	charging = true


func _on_FireballCooldown_timeout():
	can_shoot = true

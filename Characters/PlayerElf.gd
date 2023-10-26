extends KinematicBody2D

export var move_speed : float = 120
onready var _animation_player = $AnimationPlayer
const arrowPath = preload('res://items/Arrow.tscn')
var health = 6
var enemies = []
var enemies_reset = []
var immune = false
var cooldown = false
var can_dash = true
var arrow_damage = 1

func _ready():
	display_hp(health)
	GameManager.set_player(self)

func _process(delta):
	if Input.get_action_strength("eq_bow") == 1:
		$bow.visible = true
	if Input.get_action_strength("uneq_bow") == 1:
		$bow.visible = false
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("dash"):
		var dir = get_global_mouse_position()
		
		pass
	#dash(1,0)
	$Node2D.look_at(get_global_mouse_position())
	
	

func _physics_process(delta):
	GameManager.set_player_position(position)
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"))
	if input_direction.x != 0:
		if get_global_mouse_position().x < self.position.x:
			_animation_player.play("walk_left")
		else:
			_animation_player.play("walk_right")
	elif input_direction.y != 0:
		if get_global_mouse_position().x < self.position.x:
			_animation_player.play("walk_left")
		else:
			_animation_player.play("walk_right")
			
	else:
		_animation_player.play("IDLE")
		if get_global_mouse_position().x < self.position.x:
			$Sprite.flip_h = 1
		else:
			$Sprite.flip_h = 0
	if Input.is_action_just_pressed("dash"):
		dash()
		pass
	enemy_attack()
	move_and_slide(input_direction*move_speed)
	
func shoot():
	if $bow.visible and not cooldown:
		cooldown = true
		$Cooldown.start()
		var arrow = arrowPath.instance()
		arrow.damage = arrow_damage
		get_parent().add_child(arrow)
		arrow.position = $Node2D/Position2D.global_position
		$ArrowSound.play()
		arrow.velocity = get_global_mouse_position() - arrow.position
		arrow.startTimer()

func set_arrow_dmg(dmg):
	arrow_damage = dmg
	
func take_damage(damage):
	if not immune:
		immune = true
		$ImmuneTimer.start()
		health -= damage
		display_hp(health)
		$DamageTaken.play()
		$DamageTimer.start()
		flash()
		if health <= 0:
			$DamageTaken.stop()
			die()
	
func flash():
	$Sprite.modulate = Color(1,1,1,0.5)
	$Sprite.modulate = Color(255,255,255)	
func reset_flash():
	$Sprite.modulate = Color(1, 1, 1, 1)  # Reset the sprite's color

func die():
	GameManager.set_player_dead(true)
	position = GameManager.get_player_checkpoint()
	GameManager.set_player_position(position)
	health = 6
	reset_enemies()
	enemies.clear()
	enemies_reset.clear()
	display_hp(health)
	$DeathSound.play()
	$DamageTaken.volume_db=-100
	
func enemy_attack():
	if enemies: #if enemies close not empty
		for enemy in enemies:
			var damage = enemy.deal_damage()
			if damage == 0:
				pass
			else:
				$DamageTaken.volume_db=-9
				take_damage(damage)

func reset_enemies():
	if enemies_reset:
		for enemy in enemies_reset:
			enemy.reset()

func display_hp(hp):
	$Camera2D/Health/HP6.visible = false
	$Camera2D/Health/HP5.visible = false
	$Camera2D/Health/HP4.visible = false
	$Camera2D/Health/HP3.visible = false
	$Camera2D/Health/HP2.visible = false
	$Camera2D/Health/HP1.visible = false
	match hp:
		6:
			$Camera2D/Health/HP6.visible = true
		5:
			$Camera2D/Health/HP5.visible = true
		4:
			$Camera2D/Health/HP4.visible = true
		3:
			$Camera2D/Health/HP3.visible = true
		2:
			$Camera2D/Health/HP2.visible = true
		1:
			$Camera2D/Health/HP1.visible = true
			
	pass

func dash():
	if can_dash:
		$DashCooldown.start()
		move_speed = move_speed * 3
		can_dash = false
		$DashTimer.start()

func _on_DamageArea_body_entered(body):
	if body.has_method("deal_damage"):
		enemies.append(body)

func _on_DamageArea_body_exited(body):
	enemies.erase(body)
	
func player():
	pass

func _on_DamageTimer_timeout():
	reset_flash()

func _on_ImmuneTimer_timeout():
	immune = false

func _on_Cooldown_timeout():
	cooldown = false

func _on_ResetArea_body_entered(body):
	if body.has_method("enemy"):
		enemies_reset.append(body)

func _on_ResetArea_body_exited(body):
	enemies_reset.erase(body)

func _on_DashTimer_timeout():
	move_speed = 120
	pass # Replace with function body.

func _on_DashCooldown_timeout():
	can_dash = true

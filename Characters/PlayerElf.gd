extends KinematicBody2D

export var move_speed : float = 120
onready var _animation_player = $AnimationPlayer
const arrowPath = preload('res://items/Arrow.tscn')
var health = 6
var enemies = []
var immune = false


func _ready():
	display_hp(health)

func _process(delta):
	if Input.get_action_strength("eq_bow") == 1: #bara tillfälligt
		$bow.visible = true
	if Input.get_action_strength("uneq_bow") == 1:
		$bow.visible = false
	if Input.is_action_just_pressed("shoot"):
		shoot()
	#if Input.is_action_just_pressed("menu"):
	#	get_tree().change_scene("res://Menus/Menu.tscn")
	#display_hp(health)
	GameManager.set_player_position(position)
	$Node2D.look_at(get_global_mouse_position())
	
	

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"))

#	if input_direction.x == -1:
#		_animation_player.play("walk_left")
#	elif input_direction.x == 1:
#		_animation_player.play("walk_right")

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
	enemy_attack()
	move_and_slide(input_direction*move_speed)
	
func shoot():
	if $bow.visible:
		var arrow = arrowPath.instance()
		get_parent().add_child(arrow)
		arrow.position = $Node2D/Position2D.global_position
		$ArrowSound.play()
		arrow.velocity = get_global_mouse_position() - arrow.position
		arrow.startTimer()

	
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
			print("should die")
			die()
	
func flash():
	$Sprite.modulate = Color(1,1,1,0.5)
	$Sprite.modulate = Color(255,255,255)	
func reset_flash():
	$Sprite.modulate = Color(1, 1, 1, 1)  # Reset the sprite's color

func die():
	#game over/restart from checkpoint
	#queue_free()
	print("game over")
	
func enemy_attack():
	if enemies: #if enemies close not empty
		for enemy in enemies:
			var damage = enemy.deal_damage()
			if damage == 0:
				pass
			else:
				print("dmg is: ", damage)
				take_damage(damage)

func display_hp(hp):
	#$Camera2D/Health.visible = false
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

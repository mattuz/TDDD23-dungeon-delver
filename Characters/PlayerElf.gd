extends KinematicBody2D

export var move_speed : float = 120
onready var _animation_player = $AnimationPlayer

func _process(delta):
	if Input.get_action_strength("eq_bow") == 1: #bara tillfälligt
		$bow.visible = true
	if Input.get_action_strength("uneq_bow") == 1:
		$bow.visible = false
	pass

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
	else:
		_animation_player.play("IDLE")
		if get_global_mouse_position().x < self.position.x:
			$Sprite.flip_h = 1
		else:
			$Sprite.flip_h = 0
	
	move_and_slide(input_direction*move_speed)

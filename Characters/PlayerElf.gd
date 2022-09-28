extends KinematicBody2D

export var move_speed : float = 120
onready var _animation_player = $AnimationPlayer

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"))

	if input_direction.x == -1:
		_animation_player.play("walk_left")
	elif input_direction.x == 1:
		_animation_player.play("walk_right")
	else:
		_animation_player.play("IDLE")
	
	move_and_slide(input_direction*move_speed)

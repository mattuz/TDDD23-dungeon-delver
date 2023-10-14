extends KinematicBody2D

export var move_speed : float = 120
onready var _animation_player = $AnimationPlayer
const arrowPath = preload('res://items/Arrow.tscn')
var health = 3


func _process(delta):
	if Input.get_action_strength("eq_bow") == 1: #bara tillfälligt
		$bow.visible = true
	if Input.get_action_strength("uneq_bow") == 1:
		$bow.visible = false
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	$Node2D.look_at(get_global_mouse_position())
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
	
func shoot():
	if $bow.visible:
		var arrow = arrowPath.instance()
		get_parent().add_child(arrow)
		arrow.position = $Node2D/Position2D.global_position

		arrow.velocity = get_global_mouse_position() - arrow.position
		arrow.startTimer()

	
func take_damage(damage):

	health -= damage

	if health <= 0:
		die()
	
func die():
	#game over/restart from checkpoint
	print("game over")

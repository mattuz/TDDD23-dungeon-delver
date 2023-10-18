extends KinematicBody2D


var velocity = Vector2(0,0)
var speed = 300
var damage = 1



func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	look_at(position+velocity)
	if collision_info: 
		velocity=Vector2(0,0)
	
	
func _ready():
	# Connect the timer's timeout signal to a function in the Arrow script
	$DespawnTimer.connect("timeout", self, "_on_DespawnTimer_timeout")

func _on_DespawnTimer_timeout():
	queue_free()  # Remove the arrow from the scene tree
	
func startTimer():
	$DespawnTimer.start()


func _on_body_entered(body):
	if body.has_method("take_damage"):
		$Area2D/CollisionShape2D.set_deferred("disabled",true)
		self.visible = false
		$ArrowHit.play()
		body.take_damage(damage)

		$QueueTimer.start()



func _on_QueueTimer_timeout():
	queue_free()

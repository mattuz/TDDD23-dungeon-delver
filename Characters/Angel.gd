extends KinematicBody2D

var speed = 200

var chat_messages = [
	"Hello, how can I help you?",
	"I heard there's treasure in the forest.",
	"The key to the dungeon is hidden in the mountains."
]
var current_message = 0
var chatbox

func _ready():
	$AnimatedSprite.playing = true
	$AnimatedSprite.play("IDLE")
	chatbox = $Chatbox
	chatbox.show_message(chat_messages[current_message])


func _process(delta):
	if GameManager.player_position.x > position.x:
		$AnimatedSprite.play("IDLE")
		$AnimatedSprite.flip_h = 0
	else:
		$AnimatedSprite.play("IDLE")
		$AnimatedSprite.flip_h = 1



func interact():
	chatbox.show_message(chat_messages[current_message])
	current_message = (current_message + 1) % chat_messages.size()

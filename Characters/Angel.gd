extends KinematicBody2D

var speed = 200

var chat_messages = [
	"Adventurer, the princess needs your help! She's trapped deep within the dungeon. Go after her!",
	"Chests can contain useful things such as health potions, or effects that enhance your bow!",
	"Quickly, this way!"
]
var current_message = 0
var chatbox

func _ready():
	$AnimatedSprite.playing = true
	$AnimatedSprite.play("IDLE")
	$AnimatedSprite.flip_h = 1
	chatbox = $Chatbox
	chatbox.show_message(chat_messages[current_message])


func _process(delta):
	if GameManager.player_position.x > position.x:
		$AnimatedSprite.play("IDLE")
		$AnimatedSprite.flip_h = 0
		#print("0")
	else:
		#print("1")
		$AnimatedSprite.play("IDLE")
		$AnimatedSprite.flip_h = 1
	



func show_message():
	chatbox.show_message(chat_messages[current_message])
	#current_message = (current_message + 1) % chat_messages.size()

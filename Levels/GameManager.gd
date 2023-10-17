extends Node2D

var player_position = Vector2()
var player_health = 6 #player starting health

func _ready():
	pass
	
func set_player_health(health):
	player_health = health

func get_player_health():
	return player_health

# Function to set the player's position
func set_player_position(position):
	player_position = position

# Function to get the player's position
func get_player_position():
	return player_position

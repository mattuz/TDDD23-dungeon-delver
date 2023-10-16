extends Node2D

var player_position = Vector2()

func _ready():
	pass

# Function to set the player's position
func set_player_position(position):
	player_position = position

# Function to get the player's position
func get_player_position():
	return player_position

extends Node2D

var player_position = Vector2()
var in_combat = []



# Function to set the player's position
func set_player_position(position):
	player_position = position

# Function to get the player's position
func get_player_position():
	return player_position

func add_to_combat(monster):
	print("Added ", monster, " to combat")
	in_combat.append(monster)
	#How to add into combat below (used for larger mobs/bosses):
	#	if combat == false:
	#	combat = true
	#	GameManager.add_to_combat(self)
	
func remove_from_combat(monster):
	print("Removed ", monster, " from combat")
	in_combat.erase(monster)

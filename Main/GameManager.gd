extends Node2D

var player_position = Vector2()
var checkpoint_position = Vector2()
var player_dead = false
var in_combat = []
var player 
var game_won = false


func set_player(player_c):
	player = player_c

func set_player_position(position):
	player_position = position

func get_player_position():
	return player_position

func set_player_dead(dead):
	player_dead = dead

func get_player_dead():
	return player_dead

func set_player_checkpoint(pos):
	checkpoint_position = pos
	
func get_player_checkpoint():
	return checkpoint_position
	
func respawn(player):
	
	pass

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

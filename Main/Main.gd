extends Node2D

func _ready():
	#$GameMusic.playing = true
#	print($GameMusic)
	pass
	
func _process(_delta):
	if GameManager.in_combat:
		$GameMusic.playing = false
		if $GameCombatMusic.playing == false:
			$GameCombatMusic.play()
	else:
		$GameCombatMusic.playing = false
		if $GameMusic.playing == false:
			$GameMusic.play()
	if GameManager.get_player_dead():
		var current_value = get_tree().paused
		get_tree().paused = !current_value
		$CanvasLayer/respawn_menu.show()

func _input(event):
	if event.is_action_pressed("pause_menu"):
		var current_value = get_tree().paused
		get_tree().paused = !current_value
		$CanvasLayer/PauseMenu.show()

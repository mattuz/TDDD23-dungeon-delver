extends Node2D

var time = 0.0
var time_str = ""
var moved = false

func _ready():
	$CanvasLayer/PauseMenu.hide()
	$CanvasLayer/retryMenu.hide()
	$CanvasLayer/winMenu.hide()
	#$GameMusic.playing = true
#	print($GameMusic)
	$PlayerElf.arrow_damage = 2
	$PlayerElf/Cooldown.wait_time = .5
	GameManager.game_won = false
	pass
	
func _process(delta):
	moved()
	if moved:
		time += delta
	$PlayerElf/Node2D2/Panel/TimerLabel.text = str("Time: ", time)
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
		$CanvasLayer/retryMenu.show()
		time = 0.0
		moved=false
	if $boss.dead:
		$CanvasLayer/winMenu/Panel/VBoxContainer/Label.text = str("Congratulations! \n \n You managed to defeat the boss in \n ", time, " seconds! \n \n \n \n")
		$GameWin.play()
		var current_value = get_tree().paused
		get_tree().paused = !current_value
		$CanvasLayer/winMenu.show()
	
func moved():
	if GameManager.player_starting_position != GameManager.get_player_position():
		moved = true

func _input(event):
	if event.is_action_pressed("pause_menu"):
		var current_value = get_tree().paused
		get_tree().paused = !current_value
		$CanvasLayer/PauseMenu.show()

extends Control


#var respawn = false


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	pass


func _on_RetryChallengeButton_pressed():
	GameManager.set_player_dead(false)
	hide()
	get_tree().paused = false

func _on_MainMenuButton_pressed():
	$confirmExitMenu.menu = true
	$Control.hide()
	$confirmExitMenu.show()
	pass # Replace with function body.


func _on_ExitGameButton_pressed():
	$Control.hide()
	$confirmExitMenu.show()



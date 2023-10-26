extends Control


#var respawn = false


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	pass


func _on_RespawnButton_pressed():
	GameManager.set_player_dead(false)
	print("respawn")
	hide()
	get_tree().paused = false

func _on_ExitGameButton_pressed():
	$Control.hide()
	$confirmExitMenu.show()

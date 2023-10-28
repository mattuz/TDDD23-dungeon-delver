extends Control



# Called when the node enters the scene tree for the first time.
func _ready():

	pass

	


func _on_SpeedrunMode_pressed():
	get_tree().change_scene("res://Main/Speedrun.tscn")


func _on_BossMode_pressed():
	#get_tree().change_scene()
	pass # Replace with function body.
	
	
func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://Main/Menu.tscn")


func _on_ExitGameButton_pressed():
	$Control.hide()
	$confirmExitMenu.show()
	#get_tree().quit()





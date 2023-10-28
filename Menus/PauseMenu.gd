extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	pass


func _on_ContinueButton_pressed():
	hide()
	get_tree().paused = false
	


func _on_OptionsButton_pressed():
	pass # Replace with function body.


func _on_MainMenuButton_pressed():
	$confirmExitMenu.menu = true
	$Control.hide()
	$confirmExitMenu.show()
	pass # Replace with function body.


func _on_ExitGameButton_pressed():
	$confirmExitMenu.exit = true
	$Control.hide()
	$confirmExitMenu.show()
	#get_tree().quit()

extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	pass


func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://Main/Menu.tscn")


func _on_ExitGameButton_pressed():
	get_tree().quit()

extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	pass # Replace with function body.


func _on_StartButton_pressed():
	get_tree().change_scene("res://Main/Main.tscn")


func _on_AdditionalButton_pressed():
	get_tree().change_scene("res://Menus/GameModeMenu.tscn")
	
	
func _on_QuitButton_pressed():
	get_tree().quit()



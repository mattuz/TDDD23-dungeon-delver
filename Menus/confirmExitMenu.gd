extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var exit = false
var menu = false
var retry = false
var respawn = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_yes_pressed():
	if exit:
		exit = false
		get_tree().quit()
	elif menu:
		menu = false
		if retry:
			retry = false
			GameManager.set_player_dead(false)
		if respawn:
			respawn = false
			GameManager.set_player_dead(false)
			
		print(get_parent())
		get_tree().change_scene("res://Main/Menu.tscn")


func _on_no_pressed():
	exit = false
	menu = false
	hide()
	get_parent().get_node("Control").show()

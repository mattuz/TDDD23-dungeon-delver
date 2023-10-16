extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.


# Make the script a singleton
func _ready():
	print("GameManager exists")
	if not Engine.has_singleton("GameManager"):
		var game_manager = preload("res://Levels/GameManager.gd").instance()
		Engine.add_singleton("GameManager", game_manager)

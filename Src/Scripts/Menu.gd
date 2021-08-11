extends Node2D


func _ready():
	Global.load_game()

func _input(event):
	if event.is_action_pressed("jump"):
		Global.teleport(0, Vector2(416,512))

extends Node2D


onready var player_scene = preload("res://Src/Objects/Player.tscn")
onready var player_spawn = $PlayerSpawn
export var ScreenID : int

var player

func _ready():
	player_spawn.position = Global.save_position
	player = player_scene.instance()
	player.position = player_spawn.position
	add_child(player)

extends Node2D


onready var debug_label = $DebugLabel
onready var player = $Player
onready var player_scene = preload("res://Src/Objects/Player.tscn")
onready var platforms = [$Platform]

func _physics_process(delta):
	if has_node("Player"):
		debug_label.text = "X: " + var2str(player.global_position.x)
		debug_label.text += "\nY: " + var2str(player.global_position.y)
		debug_label.text += "\nHorizontal speed: " + var2str(player.velocity.x)
		debug_label.text += "\nVertical speed: " + var2str(player.velocity.y)
		debug_label.text += "\nOn floor: " + var2str(player.is_on_floor())
		debug_label.text += "\nJumping: " + var2str(player.jumping)
		debug_label.text += "\nAvailable double jump: " + var2str(player.double_jump)

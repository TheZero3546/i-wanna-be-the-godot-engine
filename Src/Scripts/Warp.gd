extends Area2D


export var teleport_id : int
export var spawn_point : Vector2

func _on_Warp_body_entered(body):
	Global.teleport(teleport_id, spawn_point)

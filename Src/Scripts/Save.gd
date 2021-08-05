extends Area2D

onready var animation = $Sprite
onready var animation_timer = $AnimationTimer


func _on_Save_area_entered(area):
	animation.frame = 1
	Global.save_position = get_parent().get_node("Player").global_position
	Global.save()
	animation_timer.start()


func _on_AnimationTimer_timeout():
	animation_timer.stop()
	animation.frame = 0

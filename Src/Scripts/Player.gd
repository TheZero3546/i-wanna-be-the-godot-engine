extends KinematicBody2D

var h_speed = 3
var direction = 1

var MAX_FALL_SPEED = 9
var gravity = 0.4
var jump_force = -8.5
var double_jump_force = -7
var jump_release_limit = 0.45

var jumping = true
var double_jump = true
var platform = false

var bullet = preload("res://Src/Objects/Bullet.tscn")
var max_bullets = 5
var bullets = 0

var velocity = Vector2()

onready var sprite = $Sprite
onready var jump_sound = $JumpSound
onready var d_jump_sound = $DoubleJumpSound
onready var death_sound = $DeathSound

func _process(_delta):
	get_input()
	
	velocity.y += gravity
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
	
	if is_on_floor():
		if not velocity.x == 0:
			sprite.animation = "Run"
		else:
			sprite.animation = "Idle"
	else:
		if velocity.y < 0:
			sprite.animation = "Jump"
		else:
			sprite.animation = "Fall"
	
	# FIXME: move the entire movement solver to repeated move_and_collide calls instead of using move_and_slide
	move_and_slide(velocity/_delta,Vector2(0,-1))
	
	if is_on_floor():
		velocity.y = 0
		jumping = false
		double_jump = true
	else:
		jumping = true
	
	if is_on_ceiling():
		velocity.y = 0

var frames_moving = 0

func get_input():
	velocity.x = 0
	
	if Input.is_action_pressed("right"):
		if frames_moving > 0:
			velocity.x += h_speed
		if direction == -1:
			$Sprite.position.x += 1
			$Hull.position.x += 2
			#position.x -= 1
			direction = 1
			scale.x = -1
			#$Hull.position.x = 2.5
		frames_moving += 1
	elif Input.is_action_pressed("left"):
		if frames_moving > 0:
			velocity.x -= h_speed
		if direction == 1:
			$Sprite.position.x -= 1
			$Hull.position.x -= 2
			#position.x += 1
			direction = -1
			scale.x = -1
			#$Hull.position.x = 1.5
		frames_moving += 1
	else:
		frames_moving = 0
	
	if Input.is_action_just_pressed("jump"):
		if jumping and double_jump and not platform:
			velocity.y = double_jump_force
			double_jump = false
			d_jump_sound.play()
		if not jumping or platform:
			velocity.y = jump_force
			jumping = true
			double_jump = true
			jump_sound.play()
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = velocity.y*0.45
	
	if Input.is_action_just_pressed("shoot"):
		if bullets < max_bullets:
			var new_bullet = bullet.instance()
			new_bullet.parent = self
			new_bullet.position = position
			get_parent().add_child(new_bullet)
			bullets += 1


func _on_SpikeCollision_body_entered(body):
	Global.die(self)


func _on_PlatformCollision_body_entered(body):
		platform = true


func _on_PlatformCollision_body_exited(body):
	platform = false

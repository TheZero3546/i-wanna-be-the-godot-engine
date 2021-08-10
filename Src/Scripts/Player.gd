extends KinematicBody2D

var h_speed = 150
var direction = 1

var MAX_FALL_SPEED = 400
var gravity = 1100
var jump_force = -415
var double_jump_force = -363

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

func _physics_process(delta):
	velocity.y += gravity * delta
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
	get_input()
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
	move_and_slide(velocity,Vector2(0,-1))
	
	if is_on_floor():
		velocity.y = 0
		jumping = false
		double_jump = true
	else:
		 jumping = true
	
	if is_on_ceiling():
		velocity.y = 0

func get_input():
	velocity.x = 0
	
	if Input.is_action_pressed("right"):
		velocity.x += h_speed
		if direction == -1:
			direction = 1
			scale.x = -1
	elif Input.is_action_pressed("left"):
		velocity.x -= h_speed
		if direction == 1:
			direction = -1
			scale.x = -1
	
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
	
	if Input.is_action_just_released("jump") and velocity.y < -130:
		velocity.y = -130
	
	if Input.is_action_just_pressed("shoot"):
		if bullets < max_bullets:
			var new_bullet = bullet.instance()
			new_bullet.position = position
			get_parent().add_child(new_bullet)
			bullets += 1


func _on_SpikeCollision_body_entered(body):
	Global.die(self)


func _on_PlatformCollision_body_entered(body):
		platform = true


func _on_PlatformCollision_body_exited(body):
	platform = false

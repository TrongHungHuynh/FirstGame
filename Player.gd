extends KinematicBody2D


# physics
var move_speed : int = 50
# jump_height = 50
# jump_duration = 0.5
var gravity : int = 400  # gravity = 2 * jump_height / pow(jump_duration, 2)
var jump_velocity : int = -200  # jump_velocity = -sqrt(2 * gravity * jump_height)

var is_jumping : bool = false
var velocity : Vector2 = Vector2()

# components
onready var player = $AnimatedSprite


func _physics_process(delta):
	
	get_input()
	
	# gravity
	velocity.y += gravity * delta
	
	if is_jumping and is_on_floor():
		is_jumping = false
	
	# applying the velocity
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	manage_animations()


func get_input():
	
	# reset horizontal velocity
	velocity.x = 0
	
	# movement inputs
	if Input.is_action_pressed("move_left"):
		velocity.x -= move_speed
	if Input.is_action_pressed("move_right"):
		velocity.x += move_speed
	
	# jump input
	if Input.is_action_just_pressed("jump") and is_on_floor():
		# drop thought platform
		if Input.is_action_pressed("down"):
			# disable player's collision at bit 1 (layer 2)
			set_collision_mask_bit(1, false)
		else:
			is_jumping = true
			velocity.y = jump_velocity
	
	if Input.is_action_just_released("jump"):
		if get_collision_mask_bit(1) == false:
			# enable player's collision at bit 1 (layer 2)
			set_collision_mask_bit(1, true)


func manage_animations():
	
	# flipping the sprite
	if velocity.x < 0:
		player.flip_h = true
	elif velocity.x > 0:
		player.flip_h = false
		
	if is_on_floor():
		if velocity.x == 0:
			play_animation("Idle")
		else:
			play_animation("Walk")
	else:
		if velocity.y < 0:
			play_animation("Jump")
		elif velocity.y > 0:
			play_animation("Fall")


func play_animation(anim):
	
	if player.animation != anim:
		player.play(anim)


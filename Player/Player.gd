extends KinematicBody2D

const ACCELERATION = 500 # how fast the player gains speed
const MAX_SPEED = 80 # how fast the player can move
const FRICTION = 500 # how long it takes for the player to lose speed when not moving

var velocity = Vector2.ZERO 

onready var animationPlayer = $AnimationPlayer

func _physics_process(delta): # If something changes & is connected to frame rate you have to multiplie"*" with delta
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized() #Makes moving in multiple directions the same speed as moving in 1 direction
	
	if input_vector != Vector2.ZERO: # If the input vector is not equal to vector2
		if input_vector.x > 0:
			animationPlayer.play("RunRight")
		else:
			animationPlayer.play("RunLeft")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	
	else: # If the input vector is equal to vector2
		animationPlayer.play("IdleRight")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)

extends KinematicBody2D

const ACCELERATION = 500 # how fast the player gains speed
const MAX_SPEED = 80 # how fast the player can move
const FRICTION = 500 # how long it takes for the player to lose speed when not moving
const ROLL_SPEED = 1.5

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO 
var roll_vector = Vector2.LEFT

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var SwordHitBox = $HitboxPivot/SwordHitbox

func _ready():
	animationTree.active = true
	SwordHitBox.knockback_vector = roll_vector

func _physics_process(delta): # If something changes & is connected to frame rate you have to multiplie"*" with delta
	match state:
		MOVE:
			move_state(delta)
		
		ROLL:
			roll_state(delta)
		
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized() #Makes moving in multiple directions the same speed as moving in 1 direction
	
	if input_vector != Vector2.ZERO: # If the input vector is not equal to vector2
		roll_vector = input_vector
		SwordHitBox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	
	else: # If the input vector is equal to vector2
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("roll"): # Allows either pressing or holding to perform this action
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state(delta):
	velocity = roll_vector * MAX_SPEED * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	velocity = velocity / 1
	state = MOVE

func attack_animation_finished():
	state = MOVE

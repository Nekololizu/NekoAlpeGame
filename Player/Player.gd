extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 125
export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")
onready var sword_hitbox = $HitboxPivot/SwordHitbox

func _ready() -> void:
	anim_tree.active = true
	sword_hitbox.knockback_vector = roll_vector

func _physics_process(delta: float) -> void:
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
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hitbox.knockback_vector = input_vector
		anim_tree.set("parameters/Idle/blend_position", input_vector)
		anim_tree.set("parameters/Run/blend_position", input_vector)
		anim_tree.set("parameters/Attack/blend_position", input_vector)
		anim_tree.set("parameters/Roll/blend_position", input_vector)
		anim_state.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		anim_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL


func attack_state(delta):
	velocity = Vector2.ZERO
	anim_state.travel("Attack")

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	anim_state.travel("Roll")
	move(velocity)
	
func move(inp_vel):
	velocity = move_and_slide(velocity)

func attack_animation_finished():
	state = MOVE
	
func roll_animation_finished():
	velocity *=  0.8
	state = MOVE

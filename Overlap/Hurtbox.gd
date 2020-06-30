extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var iframe = false setget set_iframe

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

signal iframe_started
signal iframe_ended

func set_iframe(value):
	iframe = value
	if iframe == true:
		emit_signal("iframe_started")
	else:
		emit_signal("iframe_ended")

func start_iframe(duration):
	self.iframe = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_Timer_timeout():
	self.iframe = false

func _on_Hurtbox_iframe_started():
	collisionShape.set_deferred("disabled", true)

func _on_Hurtbox_iframe_ended():
	collisionShape.disabled = false

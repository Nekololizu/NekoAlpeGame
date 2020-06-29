extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var iframe = false setget set_iframe

onready var timer = $Timer

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
	set_deferred("monitorable", false)

func _on_Hurtbox_iframe_ended():
	set_deferred("monitorable", true)

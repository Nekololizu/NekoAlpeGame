extends Node2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		var grassEffect = load("res://Effects/GrassEffect.tscn").instance()
		get_parent().add_child(grassEffect)
		grassEffect.position = position
		queue_free()

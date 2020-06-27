extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	create_grass_effect()
	queue_free()

func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.position = position

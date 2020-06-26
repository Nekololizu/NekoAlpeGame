extends Node2D

onready var anim_sprite = $AnimatedSprite

func _ready() -> void:
	anim_sprite.play("Animate")
	anim_sprite.frame = 0
	
	yield(anim_sprite, "animation_finished")
	queue_free()

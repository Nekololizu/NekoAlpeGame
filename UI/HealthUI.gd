extends Control

var hp = 4 setget set_hp
var max_hp = 4 setget set_max_hp

onready var hpUIFull = $HpUIFull
onready var hpUIEmpty = $HpUIEmpty

func set_hp(value):
	hp = clamp(value, 0, max_hp)
	if hpUIFull != null:
		hpUIFull.rect_size.x = hp * 15

func set_max_hp(value):
	max_hp = max(value, 1)
	self.hp = min(hp, max_hp)
	if hpUIEmpty != null:
		hpUIEmpty.rect_size.x = max_hp * 15

func _ready():
	self.max_hp = PlayerStats.max_health
	self.hp = PlayerStats.health
	PlayerStats.connect("health_change", self, "set_hp")
	PlayerStats.connect("max_health_changed", self, "set_max_hp")

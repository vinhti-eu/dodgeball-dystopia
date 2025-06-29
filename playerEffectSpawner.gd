extends Node2D

var number = preload("res://effectScenes/damageEffect.tscn")
onready var arena = get_tree().current_scene

func hit(a):
	var v = number.instance()
	v.global_position = self.global_position
	v.z_index = 100
	v.get_node("DamageNumber").text = str(a)
	arena.add_child(v)  # Add it to the scene tree

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

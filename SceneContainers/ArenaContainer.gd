extends Node2D

#container node for Arena, set all serialized objects here 

export var arenaScene = preload("res://Arena.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var instancedArenaScene = arenaScene.instance()
	add_child(instancedArenaScene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

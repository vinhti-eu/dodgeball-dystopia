extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate = Color(1,1,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = get_parent().get_node("Left").current_player.position

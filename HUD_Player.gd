extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health
var max_health



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("TextureProgress").value = get_node("TextureProgress").max_value * ((float(health)/max_health))
	



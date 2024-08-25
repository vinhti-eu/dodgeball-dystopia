extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if(randi()%2 == 0):
		get_node("body/Sprite").texture = load("res://sprites/player_sprites/P1_1_body.png")
	else:
		get_node("body/Sprite").texture = load("res://sprites/player_sprites/P1_2_body.png")


func play(var animation):
	if(get_node("body/AnimationPlayer").current_animation!= animation):
		get_node("body/AnimationPlayer").play(animation)
		get_node("head/AnimationPlayer").play(animation)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

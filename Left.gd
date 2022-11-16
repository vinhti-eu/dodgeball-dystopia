extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_player = null


# Called when the node enters the scene tree for the first time.
func _ready():
	current_player = get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("ui_select")):
		if(current_player.attached_ball == null):
			switch(get_child((current_player.get_index() +1) % get_child_count()))

func switch(var player):
	current_player = player

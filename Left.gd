extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_player = null
var team_players = null

# Called when the node enters the scene tree for the first time.
func _ready():
	current_player = get_child(0)
	team_players = get_children()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("ui_select")):
		if(current_player.attached_ball == null):
			switch(get_child((current_player.get_index() +1) % get_child_count()))
	update()

func switch(var player):
	current_player = player

func _draw():
	if(current_player != null and team_players != null):
		for player in team_players:
			if(current_player != player):
				draw_line(current_player.global_position, player.global_position + current_player.global_position.normalized()  ,Color(0,1,0), 1)

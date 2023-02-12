extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_player = null
var team_players = null

func _process(delta):
	current_player = get_parent().get_node("YSort").get_node("Left").current_player
	team_players =  get_parent().get_node("YSort").get_node("Left").team_players
	update()
	
	if(Arena.debug_mode):
		for child in get_parent().get_node("YSort/Left").get_children():
			child.modulate = Color(1,1,1)	
		get_parent().get_node("YSort/Left").pass_player.modulate = Color(1,0,1)
		for child in get_parent().get_node("YSort/Right").get_children():
			child.modulate = Color(1,1,1)	
		get_parent().get_node("YSort/Left").shoot_player.modulate = Color(0,1,1)
	if(get_parent().get_node("YSort/YSort_ball/Ball").ball_is_shot):
		get_parent().get_node("YSort/YSort_ball/Ball").modulate = Color(1,0,0)
	else:
		get_parent().get_node("YSort/YSort_ball/Ball").modulate = Color(1,1,1)	

# Called when the node enters the scene tree for the first time.
func _ready():
	current_player = get_parent().get_node("YSort").get_node("Left").current_player
	team_players =  get_parent().get_node("YSort").get_node("Left").team_players

func _draw():
	print("drawing")
	if( get_node("/root/Arena").debug_mode):
			if(current_player != null and team_players != null):
				for player in team_players:
					if(current_player != player):
						draw_line(current_player.get_node("Body").get_node("catchbox").global_position, player.get_node("Body").get_node("catchbox").global_position  + current_player.global_position.normalized()  ,Color(0,1,0), 1)


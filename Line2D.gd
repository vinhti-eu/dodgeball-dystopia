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


extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_player = null
var team_players = null
var pass_player = null
var min_dist_team = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_player = get_child(0)
	team_players = get_children()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("ui_pass") and self.name =="Left"):
			#switch(get_child((current_player.get_index() +1) % get_child_count()))
		switch(get_child(min_dist_team))	
	update()
	

	
	min_dist_team = get_player_closest_to_look_direction(team_players)

	if(Arena.debug_mode):
		for child in get_children():
			child.modulate = Color(1,1,1)	
		get_child(min_dist_team).modulate = Color(1,0,1)

	
	

func get_player_closest_to_look_direction(var players):

	var min_dist = 0
	var angles = []
	var current_angle_to_min = rad2deg(current_player.position.angle_to_point(team_players[min_dist].global_position))

	var current_look_angle
	var direction = current_player.direction.normalized()
	current_look_angle =  rad2deg(direction.angle())
	if current_look_angle < 0:
		current_look_angle = current_look_angle + 360

	if (current_angle_to_min < 0):
		current_angle_to_min = current_angle_to_min + 180
		
	var current_dif_to_min = rad2deg(min(abs(current_look_angle-current_angle_to_min),360-abs(current_look_angle-current_angle_to_min)))
	for player in team_players:
			var line_between = current_player.global_position + player.global_position 
			if(player == current_player):
				angles.append(1000)
			else:	
				var angle = rad2deg(player.global_position.angle_to_point(current_player.position))
				if (angle < 0):
					angle = angle + 360

				angles.append((min(abs(current_look_angle-angle),360-abs(current_look_angle-angle))))
	for i in range(0,len(angles)):
		if(abs(angles[i])< abs(angles[min_dist])):
			min_dist = i
	
	
	
	return min_dist


func switch(var player):
	current_player = player

func _draw():
	if( get_node("/root/Arena").debug_mode== true):
		if(current_player != null and team_players != null):
			for player in team_players:
				if(current_player != player):
					draw_line(current_player.global_position, player.global_position + current_player.global_position.normalized()  ,Color(0,1,0), 1)

extends Node2D

var command = load("res://command.gd")
# var team 
var current_player = null
var team_players = null
var pass_player = null
var min_dist_team = 0

# var opponent
var opponent_players = null
var min_dist_opponent = 0
var shoot_player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	current_player = get_child(0)
	team_players = get_children()
	opponent_players = get_parent().get_node("Right").get_children()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(self.name== "Left"):
		read_input()
	
	
	if(Input.is_action_just_pressed("ui_pass") and self.name =="Left"):
			#switch(get_child((current_player.get_index() +1) % get_child_count()))
		#switch(get_child(min_dist_team))	
		pass
	update()
	
	min_dist_team = get_player_closest_to_look_direction(team_players)
	min_dist_opponent = get_player_closest_to_look_direction(opponent_players)
	
	pass_player = get_child(min_dist_team)
	shoot_player = get_parent().get_node("Right").get_child(min_dist_opponent)
	



var moveCommand = command.MoveCommand.new()

var commands_to_execute = []

func read_input():
	var directions = []

	if Input.is_action_pressed("ui_left"):
		directions.append(Vector2(-1, 0))
	if Input.is_action_pressed("ui_right"):
		directions.append(Vector2(1, 0))
	if Input.is_action_pressed("ui_down"):
		directions.append(Vector2(0, 1))
	if Input.is_action_pressed("ui_up"):
		directions.append(Vector2(0, -1))

	if directions.size() > 0:
		var combined_direction = Vector2.ZERO
		for direction in directions:
			combined_direction += direction
		combined_direction = combined_direction.normalized()
		moveCommand.executeMove(current_player, combined_direction)
	else: moveCommand.executeMove(current_player, Vector2(0,0))


func get_player_closest_to_look_direction(var players):

	var min_dist = 0
	var angles = []
	var current_angle_to_min = rad2deg(current_player.position.angle_to_point(players[min_dist].global_position))

	var current_look_angle
	var direction = current_player.direction.normalized()
	current_look_angle =  rad2deg(direction.angle())
	if current_look_angle < 0:
		current_look_angle = current_look_angle + 360

	if (current_angle_to_min < 0):
		current_angle_to_min = current_angle_to_min + 180
		
	var current_dif_to_min = rad2deg(min(abs(current_look_angle-current_angle_to_min),360-abs(current_look_angle-current_angle_to_min)))
	for player in players:
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


					

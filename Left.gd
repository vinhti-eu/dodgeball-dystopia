extends Node2D

export var isPlayer = true

var command = load("res://command.gd")
var CPUController
# var team 
var current_player = null
var team_players = null
var pass_player = null
var min_dist_team = 0
var tactics = TACTICS.neutral


# var opponent
var opponent_players = null
var min_dist_opponent = 0
var shoot_player = null

export var p_left = "p1_left"
export var p_right = "p1_right"
export var p_down = "p1_down"
export var p_up = "p1_up"
export var p_a = "p1_a"
export var p_b = "p1_b"
export var p_c = "p1_c"

#export, since teams need to be swapped left-right
export var team_label = "Left"
export var opponent_label = "Right"

# testing a feature where player gets autoswapped if targeted by throw
export var autoswap_on_targeted = true;



signal got_ball(team)



enum TACTICS{
	neutral,
	offense,
	defense
}
		


# Called when the node enters the scene tree for the first time.
func _ready():
	CPUController = get_parent().get_node("CPUController" + self.name)
	
	get_parent().get_node("YSort_ball").get_node("Ball").connect("ball_has_crossed_field", self, "_on_ball_has_crossed_field")
	
	current_player = get_child(0)
	team_players = get_children()
	opponent_players = get_parent().get_node(opponent_label).get_children()
	
	# this connects to all the children signals
	# should replace any ineditor connection
	for e in team_players:
		e.connect("player_koed", self, "_on_player_koed")
		
	for e in opponent_players:
		e.connect("player_koed", self, "_on_opponent_koed")	
		e.connect("ball_thrown", self, "_on_ball_thrown")#by opponent	
		
	
	for i in rand_range(0,team_players.size() ):
		set_playerpos(i)
	

	var timer = Timer.new()
	timer.set_wait_time(1)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "on_timer_timeout")

	get_node("/root/Arena").add_child(timer)
	timer.start()


func _on_ball_thrown(opponent, own_player, acutal_throw):
	# this will autoswap to the player aimed at
	# PLAYTEST if it is better turned off or just to swap the swapping prio
	# or maybe only swap if the player is a spy
	if(autoswap_on_targeted and own_player!=null):
		if(own_player.spy):
			switch(own_player)
	

func _on_player_koed(player):
	print("KOEEEEEED with player:", player)
	autoSwitch()
	#the player got koed and removed from own players, now needs to be removed from oppenets
	#by connection through enemy same signal but different node
	print(player)
	print(team_players)

	team_players.erase(player)
	print(team_players)


func _on_opponent_koed(player):
	print("Enemy koed:", player)

	opponent_players.erase(player)


func _on_ball_has_crossed_field(side,spy):
	if(side and team_label == "Left" or !side and team_label == "Right"):
		if(spy):
			for player in team_players:
				if(player.spy):
					switch(player)

		

func on_timer_timeout():
	for i in range(team_players.size()):
		if(self.tactics == TACTICS.offense):
			team_players[i].location_change_time = team_players[i].location_change_time-1
		else:
			team_players[i].location_change_time = team_players[i].location_change_time-4
		if team_players[i].location_change_time <= 0:
			if(team_players.size()>=i):
				set_playerpos(i)
				team_players[i].location_change_time = randf()  * 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(isPlayer):
		read_input()
	else:
		CPUController.get_actions(current_player, tactics)
	
	update()

	
	min_dist_team = get_player_closest_to_look_direction(team_players, false)
	min_dist_opponent = get_player_closest_to_look_direction(opponent_players, true)
	
	#refer to TEAM players
	pass_player = team_players[min_dist_team]
	#shoot_player = get_parent().get_node(opponent_label).get_child(min_dist_opponent)
	shoot_player = opponent_players[min_dist_opponent]
	

	



	

func set_playerpos(i):
		if(self.tactics == TACTICS.offense or self.tactics == TACTICS.neutral):
			var vec = (Vector2.ONE * rand_range(0, 25)).rotated(rand_range(0, PI))
			if(self.team_label == "Left" ):
				if(! team_players[i].spy):
					team_players[i].pos_to_reach = (get_node("/root/Arena").positions_array[i]) + vec
				else: 
					team_players[i].pos_to_reach = (get_node("/root/Arena").left_spy)
			elif(self.team_label == "Right"):
				if(! team_players[i].spy):
					team_players[i].pos_to_reach = (get_node("/root/Arena").positions_array2[i]) + vec
				else: 
					team_players[i].pos_to_reach = (get_node("/root/Arena").right_spy)
			
		else:
			if self.team_label == "Left" and self.tactics == TACTICS.defense:
				if( ! team_players[i].spy):
					var opp = get_parent().get_node("Right").current_player
					var pos_to_reach = get_node("/root/Arena").positions_array[i] - (opp.global_position - get_node("/root/Arena").left_center)
					var left_center = get_node("/root/Arena").left_center
					var left_upleft = get_node("/root/Arena").left_upleft
					var left_downleft = get_node("/root/Arena").left_downleft
					var left_upright = get_node("/root/Arena").left_upright
					var left_downright = get_node("/root/Arena").left_downright

					var x = clamp(pos_to_reach.x, left_upleft.x, left_upright.x)
					var y = clamp(pos_to_reach.y, left_upleft.y, left_downleft.y)

					var vec = (Vector2.ONE * rand_range(0, 25)).rotated(rand_range(0, PI))
					team_players[i].pos_to_reach = Vector2(x, y) + vec
			else :
				team_players[i].pos_to_reach = get_node("/root/Arena").left_spy
			if self.team_label == "Right" and self.tactics == TACTICS.defense :
				if( ! team_players[i].spy):
					var opp = get_parent().get_node("Left").current_player
					var pos_to_reach = get_node("/root/Arena").positions_array2[i] + (opp.global_position - get_node("/root/Arena").right_center)
					var right_center = get_node("/root/Arena").right_center
					var right_upleft = get_node("/root/Arena").right_upleft
					var right_downleft = get_node("/root/Arena").right_downleft
					var right_upright = get_node("/root/Arena").right_upright
					var right_downright = get_node("/root/Arena").right_downright
					
					var x = clamp(pos_to_reach.x, right_upleft.x, right_upright.x)
					var y = clamp(pos_to_reach.y, right_downleft.y, right_upleft.y)
					
					var vec = (Vector2.ONE * rand_range(0, 25)).rotated(rand_range(0, PI))
					team_players[i].pos_to_reach = Vector2(x, y) + vec
				else :
					team_players[i].pos_to_reach = get_node("/root/Arena").right_spy


		





var moveCommand = command.MoveCommand.new()
var aCommand = command.ACommand.new()
var bCommand = command.BCommand.new()
var bCommandRelease = command.BCommandRelease.new()
var cCommand = command.CCommand.new()
var commands_to_execute = []

func read_input():
	var directions = []

	if Input.is_action_pressed(p_left):
		directions.append(Vector2(-1, 0))
	if Input.is_action_pressed(p_right):
		directions.append(Vector2(1, 0))
	if Input.is_action_pressed(p_down):
		directions.append(Vector2(0, 1))
	if Input.is_action_pressed(p_up):
		directions.append(Vector2(0, -1))

	if directions.size() > 0:
		var combined_direction = Vector2.ZERO
		for direction in directions:
			combined_direction += direction
		combined_direction = combined_direction.normalized()
		moveCommand.executeMove(current_player, combined_direction)
	else: moveCommand.executeMove(current_player, Vector2(0,0))
	
	if(Input.is_action_just_pressed(p_a)):
		aCommand.execute(current_player)
		
	if(Input.is_action_just_pressed(p_b)):
		bCommand.execute(current_player)
	
	if(Input.is_action_just_released(p_b)):
		bCommandRelease.execute(current_player)
		
	if(Input.is_action_just_pressed(p_c)):
		cCommand.execute(current_player)


func get_player_closest_to_look_direction(var players, var excludeSpy):
	
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
			elif(excludeSpy and player.spy):
				angles.append(999)
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
	if(player.is_in_own_field):
		current_player = player
		
func autoSwitch():
	switch(pass_player)

func run_to_center(player):
	var timer = Timer.new()
	timer.set_wait_time(0.15)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "on_timer_timeout_run_to_center", [player])
	add_child(timer)
	timer.start()

		


func on_timer_timeout_run_to_center(player):
	print("jau freezing")
	if(player == current_player):
		player.setFreezing(0.5)
		if(pass_player!= null):
			switch(pass_player)
	else:
		player.setFreezing(0)
	if(team_players.size()>player.get_index()):
		set_playerpos(player.get_index())
	



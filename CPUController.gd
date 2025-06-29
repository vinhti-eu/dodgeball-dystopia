extends Node

var command = load("res://command.gd")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var jump = false;
var passes = 0; 
var throw = false;


var has_ball = false
onready var ball = get_node("../YSort_ball/Ball")
var ball_is_lying 

var ball_side_left = true




# Called when the node enters the scene tree for the first time.
func _ready():
	#ball node to listen for ball signals
	var ball = get_parent().get_node("YSort_ball/Ball")
	ball.connect("ball_has_crossed_field",self, "_on_ball_has_crossed_field")
	has_ball = self.name == "CPUControllerLeft"
	ball_is_lying = self.name == "CPUControllerLeft"

	
	var timer2 = Timer.new()
	timer2.set_wait_time(2.5)
	timer2.set_one_shot(false)


	var arena = get_node_or_null("/root/Arena")
	if arena:
		timer2.connect("timeout", self, "on_timer_timeout_pass")  # Connect first
		arena.call_deferred("add_child", timer2)
		arena.call_deferred("add_child", timer2)
		#timer is deferred, bad practice, attach to other node or self
		yield(get_tree(), "idle_frame")  # Wait one frame
		timer2.start()
	else:
		print("Arena not found! Timer not added.")




func get_actions(current_player, delta):
	var aCommand = command.ACommand.new()
	var bCommand = command.BCommand.new()
	var cCommand = command.CCommand.new()	
	var bCommandRelease = command.BCommandRelease.new()
	var moveCommand = command.MoveCommand.new()


	if(current_player.get_parent().name == "Left" and ball_side_left and ball_is_lying and  current_player.attached_ball==null ):
		run_to_ball(current_player)
	if(current_player.get_parent().name == "Right" and !ball_side_left and ball_is_lying  and  current_player.attached_ball==null):
		run_to_ball(current_player)	

	


		
	if(throw):		
		throw=false


		bCommand.execute(current_player)
		yield(get_tree().create_timer(2.0), "timeout")

		bCommandRelease.execute(current_player)
		


		#start timmer for throw release
		
		#prevent trying to pass   if trying to throw

	
	elif(passes>0 and !ball_is_lying and !throw and has_ball and current_player.attached_ball != null):	
		# prevents a double c press, so that random runs dont happen anyore
		has_ball = false
		cCommand.execute(current_player)
		
		
	if(current_player.attached_ball != null):
		run_with_ball(current_player)
		
		#aCommand.execute(current_player)
			
	#if(jump):
	#	aCommand.execute(current_player)
	#	jump = false

func run_to_ball(player):
	var move_command = command.MoveCommand.new()
	move_command.executeMove(player, ball.global_position - player.global_position)

		
func run_with_ball(player):
	var move_command = command.MoveCommand.new()
	move_command.executeMove(player, Vector2(0,0))
	

	
func on_timer_timeout_pass():

	if(passes <= 0 ):
		if(rand_range(0,100) < 50):
			passes = randi() % 3 + 1
		else: 
			setThrow()

			

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setThrow():
	throw = true



func _on_Ball_ball_stopped_on_floor(isLying):
	ball_is_lying = isLying
	passes = 0




#also on Left got Ball
func _on_Right_got_ball(team):
	if(self.name == "CPUControllerRight" and team == "Right" ||self.name == "CPUControllerLeft" and team == "Left"):
		passes = passes-1
		has_ball = true
	else:
		has_ball = false



func _on_ball_has_crossed_field(side, spy):
	ball_side_left = side
	


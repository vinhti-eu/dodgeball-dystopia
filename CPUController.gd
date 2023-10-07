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
	has_ball = self.name == "CPUControllerLeft"
	ball_is_lying = self.name == "CPUControllerLeft"

	
	var timer2 = Timer.new()
	timer2.set_wait_time(4)
	timer2.set_one_shot(false)
	timer2.connect("timeout", self, "on_timer_timeout_pass")

	get_node("/root/Arena").add_child(timer2)
	timer2.start()



func get_actions(current_player, delta):
	var aCommand = command.ACommand.new()
	var bCommand = command.BCommand.new()
	var cCommand = command.CCommand.new()	
	var bCommandRelease = command.BCommandRelease.new()


	if(current_player.get_parent().name == "Left" and ball_side_left and ball_is_lying ):
		run_to_ball(current_player)
	if(current_player.get_parent().name == "Right" and !ball_side_left and ball_is_lying ):
		run_to_ball(current_player)	
		print("runTOBALLRIGHT")
	


		
	if(throw):		
		throw=false
		print("trying to throw")
		bCommand.execute(current_player)
		yield(get_tree().create_timer(2.0), "timeout")

		bCommandRelease.execute(current_player)
		


		#start timmer for throw release
		
		#prevent trying to pass if trying to throw

	
	elif(passes>0 and !ball_is_lying and !throw and has_ball and current_player.attached_ball != null):
		
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
		if(rand_range(0,100) < 80):
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
	print(self.name," BALLISLYING",isLying)
	passes = 0




#also on Left got Ball
func _on_Right_got_ball(team):
	if(self.name == "CPUControllerRight" and team == "Right" ||self.name == "CPUControllerLeft" and team == "Left"):
		passes = passes-1
		has_ball = true
	else:
		has_ball = false



func _on_Ball_ball_has_crossed_field(side):
	ball_side_left = side
	print("ball has crossed with: ", side)

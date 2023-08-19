extends Node

var command = load("res://command.gd")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var jump = false;
var passes = 0; 
var has_ball = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	timer.set_wait_time(5)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "on_timer_timeout")

	get_node("/root/Arena").add_child(timer)
	timer.start()
	
	var timer2 = Timer.new()
	timer2.set_wait_time(5)
	timer2.set_one_shot(false)
	timer2.connect("timeout", self, "on_timer_timeout_pass")

	get_node("/root/Arena").add_child(timer2)
	timer2.start()



func get_actions(current_player, delta):
	var aCommand = command.ACommand.new()
	var cCommand = command.CCommand.new()	

	if(passes>0):
		cCommand.execute(current_player)
		passes = passes - 1
	#if(jump):
	#	aCommand.execute(current_player)
	#	jump = false

		
	
func on_timer_timeout():
	jump = true
	
func on_timer_timeout_pass():
	print("pass")
	if(passes <= 0 ):
		passes = rand_range(0,3)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

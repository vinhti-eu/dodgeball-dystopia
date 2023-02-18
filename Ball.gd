extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var attached_to = null
var direction = null
var speed = 400
var z_position = 0
var z = 0
var z_velocity = 0
var jumping = false
var ball_is_shot = null #identifies if the ball can hurt someone
var ball_is_passed = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(attached_to != null):
		self.position = attached_to.get_node("shadow").get_node("walkbox").global_position + attached_to.hand_x_offset
		z = 10 +  attached_to.z

		
		self.get_node("Ball_body").position.y = z_position - z
	

func _physics_process(delta):
	if(jumping and attached_to==null):
		if(z>=0):
			z_velocity = z_velocity -0.1
			move_and_slide(direction * speed)
		else:
			ball_is_shot = null# ball not dangerous after touching ground
			if(abs(z_velocity)> 0.1):
				z= 0
				jumping = true
				z_velocity= abs(z_velocity) * 0.5
				direction= direction * 0.5


			else:
				jumping = false
				z = 0
				direction = Vector2.ZERO
				z_velocity = 0
				for p in get_parent().get_node("Left").get_children():
					p.ready_to_catch_pass = false
				for p in get_parent().get_node("Right").get_children():
					p.ready_to_catch_pass = false
		z = z+ z_velocity 
	self.get_node("Ball_body").position.y = z_position - z
	update()


func attach(var person):
	attached_to = person

	
func throw(var vector, var speed_multiplyer,var shooting_player):
	speed = 400
	detach()	
	ball_is_shot = shooting_player
	direction = vector * speed_multiplyer
	z_velocity = 1.5
	
	
func pass(var player, var speed_multiplyer, var passing_player):
	var distance = (player.get_node("shadow").get_node("walkbox").global_position+ player.hand_x_offset -self.global_position).length()# distance in meters
	var angle = 45 # angle in degrees
	var g = 6 # acceleration due to gravity in m/s^2
	ball_is_passed = passing_player

# convert angle to radians
	var radians = angle * PI / 180

# calculate velocity
	var velocity = (distance * g) / (2 * (cos(radians) * sin(radians)))
	
	var T = (2 * (distance * sin(radians))) / g 

	# calculate horizontal velocity
	var Vx = ((distance * cos(radians)) / T)/10

	# calculate vertical velocity
	var Vz = ((distance * sin(radians) * g) / T)/10

	
	detach()	
	direction = (player.get_node("shadow").get_node("walkbox").global_position + player.hand_x_offset - self.global_position).normalized() * Vx * speed_multiplyer
	z_velocity =  Vz * speed_multiplyer #since move_and_slide already multiplies by 60
	speed = velocity

func detach():
	attached_to = null	
	jumping = true
	
func knocked(var player):
	self.direction = direction * -1
	self.z_velocity = player.z_velocity /2
	self.speed = speed/8


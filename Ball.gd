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

var ball_is_in_left_field = true
var ball_is_lying = true
signal ball_stopped_on_floor(isLying)
signal ball_has_crossed_field(side)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(attached_to != null):
		self.position = attached_to.get_node("shadow").get_node("walkbox").global_position + attached_to.hand_x_offset
		z = 10 +  attached_to.z
		self.get_node("Ball_shadow").hide()
		
		self.get_node("Ball_body").position.y = z_position - z
	else:
		self.get_node("Ball_shadow").show()
	

func _physics_process(delta):
	if(jumping and attached_to==null):
		if(z>=0):
			z_velocity = z_velocity -0.1
			move_and_slide(direction * speed)
		else:
			ball_is_shot = null# ball not dangerous after touching ground
			if(abs(z_velocity)> 0.35):
				z= 0
				jumping = true
				z_velocity= abs(z_velocity) * 0.5
				direction= direction * 0.5
				
			else:
				#there is a bug, because the thinks that after the pass, the ball is on the ground for a splitsecond
				print("BUGBUGBUGBUGBUGBUG with z =", z, "important:" , ball_is_passed, z_velocity, "speed is ", speed)
				jumping = false
				z = 0
				direction = Vector2.ZERO
				z_velocity = 0
				#for p in get_parent().get_node("Left").get_children():
				#	p.ready_to_catch_pass = false
				#for p in get_parent().get_node("Right").get_children():
				#	p.ready_to_catch_pass = false
				position.x = round(position.x)
				position.y = round(position.y)	
				print("THIS IS THE MOMENT WHERE TO SIGNAL SHOULD BE CALLED")

				emit_floor_signal()
		z = z+ z_velocity 
	self.get_node("Ball_body").position.y = z_position - z
	update()

func emit_floor_signal():
	ball_is_lying = true
	emit_signal("ball_stopped_on_floor", ball_is_lying)
	

func attach(var person):
	if(attached_to == null):
		attached_to = person
		ball_is_lying = false
		emit_signal("ball_stopped_on_floor",ball_is_lying)

	
func throw(var vector, var speed_multiplyer,var shooting_player):
	speed = 400

	ball_is_shot = shooting_player
	direction = vector * speed_multiplyer
	z_velocity = 1.5
	get_node("AudioThrow").pitch_scale = rand_range(1,1.5)
	get_node("AudioThrow").play()
	detach()	
	
func drop(var vector, var speed_of_player,var shooting_player):
	speed = speed_of_player
	z_velocity = 0
	direction = vector
	ball_is_shot = shooting_player
	detach()	



		
	
func pass(var player, var speed_multiplyer, var passing_player):
	var distance = (player.get_node("shadow").get_node("walkbox").global_position+ player.hand_x_offset -self.global_position).length()# distance in meters
	var angle = 45 # angle in degrees
	var g = 6 # acceleration due to gravity in m/s^2
	ball_is_passed = passing_player
	get_node("AudioPass").pitch_scale = rand_range(1,1.5)
	get_node("AudioPass").play()

# convert angle to radians
	var radians = angle * PI / 180

	# calculate velocity
	var velocity = (distance * g) / (2 * (sin(radians) * sin(radians)))

	# Calculate time of flight (T)
	var T = ((2 * (distance * sin(radians))) / g) * 10

	var Vx
	var Vz

	# calculate horizontal velocity
	Vx = ((distance * cos(radians)) / T)
	# calculate vertical velocity
	Vz = ((distance * sin(radians) * g) / T)


		
	

	direction = (player.get_node("shadow").get_node("walkbox").global_position + player.hand_x_offset - self.global_position).normalized() * Vx * speed_multiplyer
	z_velocity =  Vz * speed_multiplyer #since move_and_slide already multiplies by 60
	speed = velocity
	detach()	

func detach():
	attached_to = null	
	jumping = true
	
func knocked(var player):
	self.direction = direction * -1
	self.z_velocity = player.z_velocity /2
	self.speed = speed/8

func borderd():
	if(direction != null):
		self.direction = direction * -1
		self.speed = speed/8

#this should actually alert
func _on_Ball_shadow_area_entered(area):
	if(area.name == "area_player"):

		if(attached_to == null):#might lead to problems while jumping
			ball_is_in_left_field = true
			emit_signal("ball_has_crossed_field", ball_is_in_left_field)
	if(area.name == "area_enemy"):

		print("!ball is in left field")
		if(attached_to == null):
			ball_is_in_left_field = false	
			emit_signal("ball_has_crossed_field", ball_is_in_left_field)



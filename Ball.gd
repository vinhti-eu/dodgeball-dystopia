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


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(attached_to != null):
		self.position = attached_to.get_node("walkbox").global_position
		z = 10 +  attached_to.z
		self.get_node("spr_ball").position.y = z_position - z
	

func _physics_process(delta):
	if(jumping and attached_to==null):
		if(z>=0):
			z_velocity = z_velocity -0.1
			move_and_slide(direction * speed)
		else:
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
		z = z+ z_velocity 
	self.get_node("spr_ball").position.y = z_position - z
	update()


func attach(var person):
	attached_to = person

	
func throw(var vector, var speed_multiplyer):
	detach()	
	direction = vector * speed_multiplyer
	z_velocity = 1.5
	
func pass(var player, var speed_multiplyer):
	var distance = (player.global_position-self.global_position).length()*0.9# distance in meters
	var angle = 45 # angle in degrees
	var g = 6 # acceleration due to gravity in m/s^2

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
	direction = (player.global_position - self.global_position).normalized() * Vx * speed_multiplyer
	z_velocity =  Vz * speed_multiplyer #since move_and_slide already multiplies by 60
	speed = velocity

func detach():
	attached_to = null	
	jumping = true

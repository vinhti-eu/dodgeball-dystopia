extends KinematicBody2D


#possible field
var field_dict = {
	"SPY_FIELD_P":"area_player_spy",
	"SPY_FIELD_E" : "area_enemy_spy",
	"MAIN_FIELD_P": "area_player",
	"MAIN_FIELD_E":"area_enemy"
}
var ball_overlapping_fields = []

var attached_to = null
var direction = null
var speed = 400
var z_position = 0
var z = 0
var z_velocity = 0
var jumping = false
var ball_is_shot = null #identifies if the ball can hurt someone
var ball_is_passed = null
var ball_is_in_spy_temp = false
var ball_is_in_left_field_temp = true
var ball_is_in_left_field = true
var ball_is_in_spy = false
var ball_is_lying = true
signal ball_stopped_on_floor(isLying)
signal ball_has_crossed_field(side, spy)

# Called when the node enters the scene tree for the first time.
func _ready():
	# we currently start the ball in the player field
	#ball_overlapping_fields.append(field_dict.MAIN_FIELD_P)
	self.connect("ball_has_crossed_field",$"/root/Arena","_on_ball_has_crossed_field")


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
			z_velocity = z_velocity -0.075
			move_and_slide(direction * speed)
		else:
			ball_is_shot = null# ball not dangerous after touching ground
			if(abs(z_velocity)> 0.35):
				z= 0
				jumping = true
				z_velocity= abs(z_velocity) * 0.5
				direction= direction * 0.5
				# TODO emit bounce signal here for camera
				
			else:
				#there is a bug, because the thinks that after the pass, the ball is on the ground for a splitsecondf
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
		jumping = false
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
	emit_signal("ball_has_crossed_field", ball_is_in_left_field, ball_is_in_spy)#happens after the fact



		
	
func pass(var player, var speed_multiplyer, var passing_player):
	var distance = (player.get_node("shadow").get_node("walkbox").global_position+ player.hand_x_offset -self.global_position).length()# distance in meters
	#var angle = 45 # angle in degrees
	var g = 4.5 # acceleration due to gravity in m/s^2 only for ball
	ball_is_passed = passing_player
	get_node("AudioPass").pitch_scale = rand_range(1,1.5)
	get_node("AudioPass").play()

	#fixed xV , velocity in field direction multiplied by param
	
	#experimental lerp depending on distance
	# simulates slower throws on close distance and faster throws 
	# on long distance throws
	# might need a clamp and should be tested on different multipliers
	#initial xV should be at least 150 for sensible passes
	var xV = 200 * speed_multiplyer * range_lerp(distance,0,400,0.5,2)
	xV = clamp(xV,200,1000)
	var T = distance / xV
	
	z_velocity = (T * g)/2 # highest point of throw t*g

	
	

	direction = (player.get_node("shadow").get_node("walkbox").global_position + player.hand_x_offset - self.global_position).normalized() # * Vx * speed_multiplyer
	#z_velocity = # Vz * speed_multiplyer #since move_and_slide already multiplies by 60
	speed = xV
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

# TODO overlapping areas lead to a race condition, where the wrong area might take priority
# possible fix by setting a var and checking for area exited instead
# can also be checked by only checking single dot instead of whole hitbox area
func _on_Ball_shadow_area_entered(area):
	if(field_dict.values().has(area.name)):
		ball_overlapping_fields.append(area.name)


func _on_Ball_shadow_area_exited(area):
	if(ball_overlapping_fields.has(area.name)):
		ball_overlapping_fields.erase(area.name)
		#check if there is a definitive ball area
		if(ball_overlapping_fields.size() == 1):
			assign_field_and_notify()
		

func assign_field_and_notify():
	match ball_overlapping_fields[0]:
		field_dict.MAIN_FIELD_P:
			ball_is_in_spy = false
			ball_is_in_left_field = true
		field_dict.SPY_FIELD_P:
			ball_is_in_spy = true
			ball_is_in_left_field = true
		field_dict.MAIN_FIELD_E:
			ball_is_in_spy = false
			ball_is_in_left_field = false
		field_dict.SPY_FIELD_E:
			ball_is_in_spy = true
			ball_is_in_left_field = false
	emit_signal("ball_has_crossed_field", ball_is_in_left_field, ball_is_in_spy)

		

extends KinematicBody2D

# turning towards balls or other events
var is_flipped
var health = 3
var direction = Vector2();
var run_speed = 110
var attached_ball = null
var ball_is_in_area = null
var z = 0
var z_velocity = 0
var jumping = false
var z_position = 0
var ready_to_catch_pass = false
var ball_is_in_catch = null
var hand_x_offset = Vector2(7,0)
var pos_to_reach = Vector2(186, 168)
var ball_shadow_is_in_shadow =false
onready var ball = get_node("/root/Arena/YSort/YSort_ball/Ball")
var flip = Vector2(1,1)
export var spy = false
var location_change_time = 0
var is_in_own_field
signal player_koed(player)
signal ball_thrown(player, player_aimed, actual_throw)
signal player_hit(player)


var knockback_speed = 200
var knockback_direction = Vector2()
var catch_time = 0.5 #seconds
export var auto_catch_chance = 0.15

enum STATE{
	main,
	knocked,
	throwing,
	throwing_post,
	passing,
	passing_post,
	freezing,
	KO,
	removed,
	catching
}

var state = STATE.main

enum TACTICS{
	neutral,
	offense,
	defense	
}


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect("player_koed", self, "_on_player_koed")
	
	#get_node("/root/@Arena@2").get_node("Camera").connect("ball_thrown", self,"_on_ball_thrown")
	

	
	location_change_time = 0
	
	get_parent().connect("got_ball", self, "_on_got_ball")
	if(get_parent().name !='Left' and !spy || (get_parent().name =='Left') and spy):			
		get_node("Body").scale = Vector2(-1, 1)
		var sprite = self.get_node("Body").get_node("AnimatedSprite")
		sprite.frame = 1
		flip = Vector2(-1,1)
	
	is_in_own_field = true
	
	z_position = get_node("Body").get_node("AnimatedSprite").position.y
	hand_x_offset = Vector2(5,0) * flip




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# check for ball position
	# turn towards ball
	# add own function
	
	process_sprite_flip()
	
	
	if(self.state== STATE.main):
		main_state()
	elif(self.state == STATE.knocked):
		knocked_state()
	elif(self.state == STATE.throwing):
		throwing_state()
	elif(self.state==STATE.throwing_post):
		throwing_post_state()
	elif(self.state==STATE.passing):
		passing_state()
	elif(self.state==STATE.passing_post):
		passing_post()
	elif(self.state==STATE.freezing):
		freezing()
	elif(self.state==STATE.KO):
		koed_state()
	elif(self.state==STATE.removed):
		removed_state()	
	elif(self.state==STATE.catching): 
		catching_state()


func catching_state():
		get_node("Body").get_node("AnimatedSprite").modulate = (Color(0.5, 0.5,0.5,1))


func uncatch():
	self.state = STATE.main

func removed_state():
	pass

func koed_state():
	get_node("Body").get_node("AnimatedSprite").modulate = (Color(1.0, 0.2,0.2,0.4))
	self.direction = Vector2(0,0)
	get_node("Body/AnimatedSprite").animation = "knocked"
	get_parent().get_parent().get_node("Left").emit_signal('got_ball',get_parent().name)
	print("Before emitting player_koed signal")
	emit_signal('player_koed', self);
	self.state = STATE.removed
	
	


func freezing():
	get_node("Body").get_node("AnimatedSprite").modulate = (Color(0.8, 0.8 ,0.8,0.8))
	get_node("Body/AnimatedSprite").animation = "main"

	self.direction = Vector2(0,0)

func unfreeze():
	self.state = STATE.main

	
func setFreezing(freezetime):
	if(freezetime > 0):
		self.state= STATE.freezing
		
		var timer = Timer.new()
		timer.set_wait_time(freezetime)
		timer.set_one_shot(true)
		timer.connect("timeout", self, "unfreeze")
		add_child(timer)
		timer.start()



func passing_post():
#	get_node("Body/Animations").play("pass_b")
	get_node("Body").get_node("AnimatedSprite").animation = "pass"
	get_node("Body").get_node("AnimatedSprite").frame = 0
	get_node("Body").get_node("AnimatedSprite").playing   = false
	get_node("Body").get_node("AnimatedSprite").modulate = (Color(1,1,1,1))
	#get_node("Body/Animations").play("pass_a")

	yield(get_tree().create_timer(0.12), "timeout")  # Wait for one second
	get_node("Body").get_node("AnimatedSprite").animation = "pass"
	get_node("Body").get_node("AnimatedSprite").frame = 1
	get_node("Body").get_node("AnimatedSprite").playing   = false
	get_node("Body").get_node("AnimatedSprite").modulate = (Color(1,1,1,1))
	get_node("Body/Animations").play("pass_b")
	yield(get_tree().create_timer(0.15), "timeout")  # Wait for one second






	self.state= STATE.main

func throwing_post_state():
	attached_ball = null
	get_node("Body").get_node("AnimatedSprite").animation = "throw"
	get_node("Body").get_node("AnimatedSprite").frame = 1
	get_node("Body").get_node("AnimatedSprite").playing   = false
	get_node("Body").get_node("AnimatedSprite").modulate = (Color(1,1,1,1))
	get_node("Body/Animations").play("throw_b")
	
	yield(get_tree().create_timer(0.25), "timeout")  # Wait for one second

	self.state= STATE.main

func throwing_state():		
	if(attached_ball != null):
		direction= Vector2(0,0);	
		get_node("Body").get_node("AnimatedSprite").modulate = (Color(1,1,0,1))
		hand_x_offset = Vector2(-23,-4) * flip
		get_node("Body").get_node("AnimatedSprite").animation = "throw"
		get_node("Body/Animations").play("throw_a")

		get_node("Body").get_node("AnimatedSprite").playing   = false

func process_sprite_flip():

	if(attached_ball == null and get_parent().tactics != TACTICS.offense):
		if((ball.global_position.x < self.global_position.x) and get_parent().tactics):
			get_node("Body").scale = Vector2(-1, 1)	
			flip = Vector2(-1,1)
		else:
			get_node("Body").scale = Vector2(1, 1)	
			flip = Vector2(1,1)
	else:
		if(get_parent().name !='Left' and !spy || (get_parent().name =='Left') and spy):			
			get_node("Body").scale = Vector2(-1, 1)
			flip = Vector2(-1,1)
		else:
			get_node("Body").scale = Vector2(1, 1)
			flip = Vector2(1,1)
	if(spy and get_parent().tactics== get_parent().TACTICS.offense):
		if(get_parent().name =='Left'):
			if(get_parent().tactics == get_parent().TACTICS.offense and self.global_position.x >380):
				get_node("Body").scale = Vector2(-1, 1)
				flip = Vector2(-1,1)
			else:
				get_node("Body").scale = Vector2(1, 1)
				flip = Vector2(1,1)
		else:
			if(get_parent().tactics == get_parent().TACTICS.offense and self.global_position.x >196):
				get_node("Body").scale = Vector2(-1, 1)
				flip = Vector2(-1,1)
			else:
				get_node("Body").scale = Vector2(1, 1)
				flip = Vector2(1,1)
	

	
func executeBallThrow():
	emit_signal("ball_thrown", self, get_parent().shoot_player, false) #TODO XKCD
	if(attached_ball != null):	
		hand_x_offset = Vector2(15,-4) * flip
		attached_ball.position = self.position + hand_x_offset 
		var throw_direction
		if(get_parent().shoot_player !=null):
			throw_direction = (get_parent().shoot_player.get_node("shadow").get_node("walkbox").global_position - self.hand_x_offset  - self.get_node("shadow").get_node("walkbox").global_position).normalized()
			emit_signal('ball_thrown', self, get_parent().shoot_player ,true)
		else:
			throw_direction = direction 
			throw_direction.x = abs(throw_direction.x)
			throw_direction = throw_direction + Vector2(1.2,0) 
			throw_direction = throw_direction.normalized() * $"/root/Arena".y_ratio
			emit_signal('ball_thrown', self, null ,true)
		throw_ball(throw_direction)


		throwing_post_state()
	


func main_state():
	
	
	get_node("Body").get_node("AnimatedSprite").modulate = (Color(1, 1 , 1, 1 ))
	hand_x_offset = Vector2(7,0) * flip
	get_node("Body/AnimatedSprite").playing = true
	if(get_parent().name == 'Left'|| 'Right'):
		if(get_parent().current_player == self):
			run_speed = 100
			read_input();
		else:
			run_speed = 75
			ai_move()

	if(direction.length() !=0):
		if(get_node("Body/AnimatedSprite").animation != "run"):
			get_node("Body/AnimatedSprite").animation = "run"

		get_node("Body/Animations").play("run")
		if(get_node("Body/AnimatedSprite").get_frame()==1 ):
			if(attached_ball != null):
				hand_x_offset = Vector2(5,-1)*flip

				
		else:
			hand_x_offset = Vector2(7,0) * flip	
		move_and_slide(direction * run_speed);
		get_node("shadow/Particles2D").position = get_node("shadow/Particles2D").position 
		get_node("shadow/Particles2D").emitting = true
		if(direction.x <0):
			get_node("shadow/Particles2D").position.x = 11
		else:
			get_node("shadow/Particles2D").position.x = -11
	else:
		get_node("Body/Animations").play("main")
		get_node("Body/AnimatedSprite").animation = "main"
		get_node("shadow/Particles2D").emitting = false

		
	if(ball_is_in_catch and ready_to_catch_pass and ball_shadow_is_in_shadow ):
		attach_ball(ball_is_in_catch)
		ready_to_catch_pass = false;


	if(jumping):
		if(z>=0):
			z = z+ z_velocity
			z_velocity = z_velocity -0.1
			self.get_node("Body").position.y = z_position - z
		else:
			jumping = false		
			landing_from_jump()
			z = 0
	#no input needed for this one		
	if( ball_is_in_catch !=null and attached_ball ==null 
	and ball_is_in_catch.ball_is_shot==null and ball_is_in_catch.attached_to == null and (ball_is_in_catch.ball_is_passed!=self || ball_is_in_catch.ball_is_lying) and ball_shadow_is_in_shadow):
		attach_ball(ball_is_in_catch)
		ready_to_catch_pass = false;
		
func knocked_state():
	jumping = true
	self.get_node("Body/AnimatedSprite").animation = "knocked"
	get_node("Body/Animations").play("knocked")
	
	if(z>=0):
		z = z+ z_velocity
		z_velocity = z_velocity -0.1
		self.get_node("Body").position.y = z_position - z

	else:
		jumping= false
		z = 0
		z_velocity = 0
		knockback_direction = Vector2()
		knockback_speed = 0
		if(self.health <= 0):
			self.state = STATE.KO
		else: 
			landing_from_jump()
			self.state= STATE.main
	if(knockback_direction.length() !=0):
		move_and_slide(knockback_direction * knockback_speed);



func read_input():
	pass


func set_direction(move_direction):
	direction = move_direction.normalized() * $"/root/Arena".y_ratio
	
func jump():
	jumping = true
	z_velocity = 2.8

func aCommand():
	if(!jumping):
		jump()

func bCommand():
	if(state==STATE.main):	
		if(attached_ball != null):
			state = STATE.throwing
		elif (!jumping):
			var timer = Timer.new()
			timer.set_wait_time(catch_time)
			timer.set_one_shot(true)
			timer.connect("timeout", self, "uncatch")
			add_child(timer)
			timer.start()
			catch_ball()
		
		#TODO PREVENT ON CATCH STATE
func bCommandRelease():
	if(attached_ball != null and state==STATE.throwing):
		executeBallThrow()


func catch_ball():
	self.state = STATE.catching

func cCommand():
	if(state==STATE.main or state == STATE.throwing):
		if(attached_ball != null  and get_parent().current_player == self):
			self.state= STATE.passing
		if(attached_ball == null and get_parent().current_player == self):
			get_parent().switch(get_parent().pass_player) 

func _draw():
	if(get_node("/root/Arena").debug_mode):
		draw_line(global_position.normalized() ,global_position.normalized() + direction * 100 , Color(1,1,1), 1)

func landing_from_jump():
	if(!self.is_in_own_field):
		#TODO fix order of operation so that freezing happens first anyways
		has_touched_enemy_field()

func passing_state():
	if(attached_ball !=null):
		get_node("Body").get_node("AnimatedSprite").animation = "pass"
		get_node("Body").get_node("AnimatedSprite").frame = 0
		get_node("Body").get_node("AnimatedSprite").playing   = false
		
		get_node("Body/Animations").play("pass_a")
		
		hand_x_offset = Vector2(-13,0) * flip
		attached_ball.position = self.position + hand_x_offset

		var timer = Timer.new()
		timer.set_wait_time(0.15)
		timer.set_one_shot(true)
		timer.connect("timeout", self, "on_timer_timeout")
		add_child(timer)
		timer.start()

	state = STATE.passing_post #hacky solution that needs to keep in sync




func on_timer_timeout():
	hand_x_offset = Vector2(14,-2) * flip
	attached_ball.position = self.position + hand_x_offset
	pass_ball(get_parent().pass_player)

	

func has_touched_enemy_field():
	if(self.attached_ball != null):
		drop_ball(direction)
	get_parent().run_to_center(self)

func throw_ball(direction):
	attached_ball.throw(direction,1, self)
	attached_ball = null


func attach_ball(ball):
	ball.ball_is_shot = null
	if(self.is_in_own_field and attached_ball == null):
		ball.attach(self)
		attached_ball = ball
		get_parent().current_player = self
		#always called on attachement 
		# TODO replace with ball knowledge instead of player
		# Signal emission does currently not consider spies and leads to wonky camera 
		# behaviour
		get_parent().get_parent().get_node("Left").emit_signal('got_ball',get_parent().name)
		get_parent().get_parent().get_node("Right").emit_signal('got_ball',get_parent().name)

func pass_ball(player):
	attached_ball.pass(player,1, self)
	attached_ball = null
	player.ready_to_catch_pass = true
	get_parent().switch(player)

func _on_ballbox_area_entered(area):
		var ball = area.get_parent();
		if(ball.get_name()=='Ball' and ball.attached_to == null):
			ball_is_in_area = ball
			if(ball.ball_is_shot != null and ball.ball_is_shot !=self 
				and self.ball_shadow_is_in_shadow and self.state != STATE.knocked):
				if(self.state != STATE.catching):
					#if the non CPU player controls, no autochance
					if(rand_range(0,1) > auto_catch_chance):
							
						hit_by_ball(ball)
					else:
						if(get_parent().current_player == self and get_parent().isPlayer):
							hit_by_ball(ball)
						else:	
							print(get_parent().current_player != self, !get_parent().isPlayer)
							attach_ball(ball)
				else:
					attach_ball(ball)

func hit_by_ball(ball):
	emit_signal("player_hit",self)
	self.health = self.health -1
	self.state = STATE.knocked
	self.knockback_speed = ball.speed /6
	self.z_velocity = knockback_speed/30#/60 2
	knockback_direction = ball.direction.normalized()
	ball.knocked(self)
	get_parent().switch(self)
	


func _on_ballbox_area_exited(area):
		var ball = area.get_parent();
		if(ball.get_name()=='Ball'):
			ball_is_in_area = null

var move_timer_started = false

func ai_move():
	if(get_parent().tactics == TACTICS.defense):
		if((self.pos_to_reach - self.global_position).length()>1):
			direction = (self.pos_to_reach - self.global_position ).normalized()
		else:
			direction = Vector2(0,0)
	else:
		if((self.pos_to_reach - self.global_position).length()>1):
			direction = (self.pos_to_reach - self.global_position ).normalized()
		else:
			direction = Vector2(0,0)




func _on_catchbox_area_entered(area):
	var ball = area;
	if(ball.get_name()=='Ball_body'):
		ball_is_in_catch = ball.get_parent()


func _on_catchbox_area_exited(area):
	var ball = area;
	if(ball.get_name()=='Ball_body'):
		ball_is_in_catch = null


func _on_shadow_area_entered(area):
	
	if(area.get_name()=='Ball_shadow'):
		ball_shadow_is_in_shadow = true
	if(area.get_parent().name == "area_player_all" and get_parent().name == "Right" or area.get_parent().name == "area_enemy_all" and get_parent().name == "Left"):
		self.is_in_own_field = false
		if(!jumping):
			if(self.attached_ball != null):
				drop_ball(direction)
			get_parent().run_to_center(self)

		


			







func _on_shadow_area_exited(area):
	if(area.get_name()=='Ball_shadow'):
		ball_shadow_is_in_shadow = false
	if(area.get_parent().name == "area_player_all" and get_parent().name == "Right" or area.get_parent().name == "area_enemy_all" and get_parent().name == "Left"):	
		self.is_in_own_field = true	
		
func drop_ball(direction):
	attached_ball.drop(direction,  run_speed, self)
	attached_ball = null

func _on_got_ball(team) -> void:
	if team == get_parent().name:
		get_parent().tactics = TACTICS.offense
	else:
		get_parent().tactics = TACTICS.defense
		self.location_change_time = rand_range(0,1)


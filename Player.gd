extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction = Vector2();
var run_speed = 100
export var team = 'left'
var attached_ball = null
var ball_is_in_area = null
var ball_just_picked_up = false
var z = 0
var z_velocity = 0
var jumping = false
var z_position = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	z_position = get_node("AnimatedSprite").position.y



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(team == 'left'):
		if(get_parent().current_player == self):
			read_input();
		else:
			ai_move()
	if(direction.length() !=0):
		move_and_slide(direction * run_speed);
	if(jumping):
		if(z>=0):
			z = z+ z_velocity 
			z_velocity = z_velocity -0.1
			self.get_node("AnimatedSprite").position.y = z_position - z
		else:
			jumping = false
			z = 0
	update()


		
func read_input():
	direction = Vector2.ZERO.normalized()
	if Input.is_action_pressed("ui_left"):
		direction.x += -1;
	if Input.is_action_pressed("ui_right"):
		direction.x += 1;
	if Input.is_action_pressed("ui_down"):
		direction.y += 1 
	if Input.is_action_pressed("ui_up"):
		direction.y += -1;
	direction = direction.normalized() 
	direction.y = direction.y * Arena.y_ratio
	if(Input.is_action_pressed("ui_shoot") and attached_ball != null):
		direction= Vector2(0,0);
		if(!ball_just_picked_up):
			get_node("AnimatedSprite").modulate = (Color(1,1,0,1))
	if(attached_ball != null and Input.is_action_just_released("ui_shoot")):
		if(!ball_just_picked_up):
			var throw_direction = direction
			throw_direction.x = abs(throw_direction.x)
			throw_direction = throw_direction + Vector2(1.2,0)
			throw_direction = throw_direction.normalized() * Arena.y_ratio
			throw_ball(throw_direction)
		else:
			ball_just_picked_up = false 
		get_node("AnimatedSprite").modulate = (Color(1,1,1,1))
	if(Input.is_action_just_pressed("ui_shoot") and ball_is_in_area !=null and attached_ball ==null):
		attach_ball(ball_is_in_area)
		ball_just_picked_up = true;
	if(attached_ball != null and Input.is_action_just_pressed("ui_pass")):	
		pass_ball(get_parent().get_child(get_parent().min_dist_team))
	if((Input.is_action_just_pressed("ui_accept") and !jumping)):
		jumping = true
		z_velocity = 3



func _draw():
		draw_line(global_position.normalized() ,global_position.normalized() + direction * 100 , Color(1,1,1), 1)




func throw_ball(direction):
	attached_ball.throw(direction,1)
	attached_ball = null

func attach_ball(ball):
	ball.attach(self)
	attached_ball = ball
	if(self.team == 'left'):
		get_parent().current_player = self
	
func pass_ball(player):
	attached_ball.pass(player,1)
	attached_ball = null

func _on_ballbox_area_entered(area):
		var ball = area.get_parent();
		if(ball.get_name()=='Ball'):
			ball_is_in_area = ball



func _on_ballbox_area_exited(area):
		var ball = area.get_parent();
		if(ball.get_name()=='Ball'):
			ball_is_in_area = null
			
func ai_move():
	self.direction = Vector2(0,0)

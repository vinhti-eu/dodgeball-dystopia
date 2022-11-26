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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(team == 'left'):
		if(get_parent().current_player == self):
			read_input();
		else:
			ai_move()
	if(direction.length() !=0):
		move_and_slide(direction * run_speed);
	update()


		
func read_input():
	direction = Vector2.ZERO
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
	if(Input.is_action_pressed("ui_accept") and attached_ball != null):
		direction= Vector2(0,0);
		if(!ball_just_picked_up):
			get_node("AnimatedSprite").modulate = (Color(1,1,0,1))
	if(attached_ball != null and Input.is_action_just_released("ui_accept")):
		if(!ball_just_picked_up):
			var throw_direction = direction
			throw_direction.x = abs(throw_direction.x)
			throw_direction = throw_direction + Vector2(1.2,0)
			throw_direction = throw_direction.normalized() 
			throw_ball(throw_direction)
		else:
			ball_just_picked_up = false 
		get_node("AnimatedSprite").modulate = (Color(1,1,1,1))
	if(Input.is_action_just_pressed("ui_accept") and ball_is_in_area !=null and attached_ball ==null):
		attach_ball(ball_is_in_area)
		ball_just_picked_up = true;



func _draw():
	if(direction.length()>0):
		draw_line(global_position.normalized() ,global_position.normalized() + direction * 100 , Color(1,1,1), 1)




func throw_ball(direction):
	attached_ball.throw(direction,1)
	attached_ball = null

func attach_ball(ball):
	ball.attach(self)
	attached_ball = ball
	if(self.team == 'left'):
		get_parent().current_player = self
	


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

extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction = Vector2();
var run_speed = 80
export var team = 'left'
var attached_ball = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(team == 'left'):
		read_input();
	if(direction.length() !=0):
		move_and_slide(direction * run_speed);

		
func read_input():
	direction = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		direction.x += -1;
	if Input.is_action_pressed("ui_right"):
		direction.x += 1;
	if Input.is_action_pressed("ui_down"):
		direction.y += 1;
	if Input.is_action_pressed("ui_up"):
		direction.y += -1;
	direction = direction.normalized()
	if(attached_ball != null and Input.is_action_just_pressed("ui_accept")):
		throw_ball()

	

func throw_ball():
	attached_ball.throw()
	attached_ball = null

func attach_ball(ball):
	ball.attach(self)
	attached_ball = ball
	

func _on_ballbox_area_entered(area):
	var ball = area.get_parent();
	if(ball.get_name()=='Ball'):
		attach_ball(ball)

extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var postion_to_reach_x
var postion_to_reach_y
var team = "Left"

var state = STATE.auto

enum STATE{
	auto, #camera moves with own vars
	followLeft,
	followRight,
	ballLying,
	ballThrown
}


# Called when the node enters the scene tree for the first time.
func _ready():
	var players
	var players2
	players = get_parent().get_node("YSort/Left").get_children()
	players2 = get_parent().get_node("YSort/Right").get_children()

	
	# this connects to all the children signals
	# should replace any ineditor connection
	for e in players:
		e.connect("ball_thrown", self, "_on_ball_thrown")
		
	for e in players2:
		e.connect("ball_thrown", self, "_on_ball_thrown")	
		
	
	postion_to_reach_x = self.position.x
	postion_to_reach_y = self.position.y



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(self.state == STATE.auto):
		auto()
	elif(self.state == STATE.followLeft):
		followLeft(delta)
	elif(self.state == STATE.followRight):
		followRight(delta)
	elif(self.state ==  STATE.ballThrown):
		ballThrown()


func auto():
	pass
	
func followLeft(delta):

	postion_to_reach_x = ((get_parent().get_node("YSort").get_node(team).current_player.global_position.x) *1.6)-self.global_position.x  * delta;

	postion_to_reach_y = ((get_parent().get_node("YSort").get_node(team).current_player.global_position.y +15 -get_parent().get_node("YSort/Left").current_player.z *1.1))- self.global_position.x  * delta;
	gotoPosition(0.02,0.03)

func followRight(delta):

	postion_to_reach_x = ((get_parent().get_node("YSort").get_node(team).current_player.global_position.x) *1.6)-self.global_position.x  * delta -288;
	postion_to_reach_y = ((get_parent().get_node("YSort").get_node(team).current_player.global_position.y +15 -get_parent().get_node("YSort/Left").current_player.z *1.1))-self.global_position.x  * delta;
	
	gotoPosition(0.02,0.03)

func ballThrown():
	postion_to_reach_x = get_parent().get_node("YSort/YSort_ball/Ball").global_position.x
	postion_to_reach_y = get_parent().get_node("YSort/YSort_ball/Ball").global_position.y
	gotoPosition(0.04,0.06)

func gotoPosition(x_increase, y_increase):
	self.position.x = self.position.x + ((postion_to_reach_x-self.position.x) * x_increase)
	self.position.y = self.position.y + ((postion_to_reach_y-self.position.y) * y_increase)
	if(round(postion_to_reach_x) == round(position.x)):
		position.x = 	round(postion_to_reach_x)
	if(round(postion_to_reach_y) == round(position.y)):
		position.y = 	round(postion_to_reach_y)
		
		
func _on_ball_thrown(player):
	print("camera state swap")
	self.state= STATE.ballThrown



func _on_Left_got_ball(team):
	self.team = team
	if(team == "Left"):
		state = STATE.followLeft
	if(team == "Right"):
		state = STATE.followRight


func _on_Right_got_ball(team):
	self.team = team
	if(team == "Left"):
		state = STATE.followLeft
	if(team == "Right"):
		state = STATE.followRight

extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var postion_to_reach_x
var postion_to_reach_y
var team = "Left"

var trauma = 0.0
var trauma_decay = 1.2
var trauma_power = 2
export var max_offset = Vector2(10, 7.5)
var noise_y = 0
export var shake = false

signal transform_updated

onready var noise = OpenSimplexNoise.new()

var player_to_go_to

var state = STATE.auto

enum STATE{
	auto, #camera moves with own vars
	followLeft,
	followRight,a
	ballLying,
	ballThrown,
	go_to_player
}


# Called when the node enters the scene tree for the first time.
func _ready():
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	
	var players
	var players2
	players = get_parent().get_node("YSort/Left").get_children()
	players2 = get_parent().get_node("YSort/Right").get_children()

	
	# this connects to all the children signals
	# should replace any ineditor connection
	for e in players:
		e.connect("ball_thrown", self, "_on_ball_thrown")
		e.connect("player_hit", self, "_on_player_hit")
		
	for e in players2:
		e.connect("ball_thrown", self, "_on_ball_thrown")	
		e.connect("player_hit", self, "_on_player_hit")
	
		
	get_parent().get_node("YSort/YSort_ball/Ball").connect("ball_stopped_on_floor",self, "_on_ball_stoopen_on__floor")
	
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
	elif(self.state ==  STATE.ballLying):
		ballLying()
	elif(self.state == STATE.go_to_player):
		go_to_player()
	if(shake):
		if(trauma):
			trauma = max(trauma - trauma_decay * delta, 0)
			shake_screen()		
	emit_signal("transform_updated")
			
func shake_screen():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)

func auto():
	pass
	
func followLeft(delta):

	postion_to_reach_x = ((get_parent().get_node("YSort").get_node(team).current_player.global_position.x) *1.7)-self.global_position.x  * delta;

	postion_to_reach_y = ((get_parent().get_node("YSort").get_node(team).current_player.global_position.y +15 -get_parent().get_node("YSort/Left").current_player.z *1.1))- self.global_position.x  * delta;
	gotoPosition(0.03,0.045)

func followRight(delta):

	postion_to_reach_x = ((get_parent().get_node("YSort").get_node(team).current_player.global_position.x) *1.7)-self.global_position.x  * delta -288;
	postion_to_reach_y = ((get_parent().get_node("YSort").get_node(team).current_player.global_position.y +15 -get_parent().get_node("YSort/Left").current_player.z *1.1))-self.global_position.x  * delta;
	
	gotoPosition(0.03,0.045)

	# move camera to player thrown at
func ballThrown():
	postion_to_reach_x = player_to_go_to.global_position.x
	postion_to_reach_y = player_to_go_to.global_position.y
	gotoPosition(0.03,0.045)
	
	
func ballLying():
	postion_to_reach_x = get_parent().get_node("YSort/YSort_ball/Ball").global_position.x
	postion_to_reach_y = get_parent().get_node("YSort/YSort_ball/Ball").global_position.y
	gotoPosition(0.03,0.045)
	
func go_to_player():
	print("GOING?")
	postion_to_reach_x = player_to_go_to.global_position.x
	postion_to_reach_y = player_to_go_to.global_position.y
	gotoPosition(0.03,0.045)
		
	
func gotoPosition(x_increase, y_increase):
	self.position.x = self.position.x + ((postion_to_reach_x-self.position.x) * x_increase)
	self.position.y = self.position.y + ((postion_to_reach_y-self.position.y) * y_increase)
	if(round(postion_to_reach_x) == round(position.x)):
		position.x = 	round(postion_to_reach_x)
	if(round(postion_to_reach_y) == round(position.y)):
		position.y = 	round(postion_to_reach_y)
		
		
func _on_ball_thrown(player, player_aimed_at, actual_throw):
	print("camera state swap")
	player_to_go_to = player_aimed_at
	# only goes for one frame or so..
	go_to_player()

	# weird backjerk because of lacking offset
	self.state= STATE.ballThrown



func _on_Left_got_ball(team):
	print("check for change")
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

func _on_ball_stoopen_on__floor(stoped):
	self.state=STATE.ballLying

func add_trauma(trauma):
	self.trauma = self.trauma + trauma
	
func _on_player_hit(player):
	add_trauma(0.8)

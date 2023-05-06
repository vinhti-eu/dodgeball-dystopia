extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var postion_to_reach_x
var postion_to_reach_y
var team = "Left"

# Called when the node enters the scene tree for the first time.
func _ready():
	postion_to_reach_x = self.position.x
	postion_to_reach_y = self.position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(team == "Left"):
		postion_to_reach_x = ((get_parent().get_node("YSort").get_node(team).current_player.global_position.x) *1.6)-self.global_position.x  * delta;
	else:
		postion_to_reach_x = ((get_parent().get_node("YSort").get_node(team).current_player.global_position.x) *1.6)-self.global_position.x  * delta -288;
	postion_to_reach_y = ((get_parent().get_node("YSort").get_node(team).current_player.global_position.y +15 -get_parent().get_node("YSort/Left").current_player.z *1.1))-self.global_position.x  * delta;

	self.position.x = self.position.x + ((postion_to_reach_x-self.position.x) * 0.02)
	self.position.y = self.position.y + ((postion_to_reach_y-self.position.y) * 0.03)
	if(round(postion_to_reach_x) == round(position.x)):
		position.x = 	round(postion_to_reach_x)
	if(round(postion_to_reach_y) == round(position.y)):
		position.y = 	round(postion_to_reach_y)




	


func _on_Left_got_ball(team):
	self.team = team


func _on_Right_got_ball(team):
	self.team = team

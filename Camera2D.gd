extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var postion_to_reach_x
var postion_to_reach_y

# Called when the node enters the scene tree for the first time.
func _ready():
	postion_to_reach_x = self.position.x
	postion_to_reach_y = self.position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	postion_to_reach_x = ((get_parent().get_node("Left").current_player.global_position.x) *1.6)-self.global_position.x  * delta;
	postion_to_reach_y = ((get_parent().get_node("Left").current_player.global_position.y +15 -get_parent().get_node("Left").current_player.z *1.1))-self.global_position.x  * delta;
	self.position.x = self.position.x + ((postion_to_reach_x-self.position.x) * 0.08)
	self.position.y = self.position.y + ((postion_to_reach_y-self.position.y) * 0.05)


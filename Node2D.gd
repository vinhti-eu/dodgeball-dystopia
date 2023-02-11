extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var postion_to_reach

# Called when the node enters the scene tree for the first time.
func _ready():
	postion_to_reach = self.position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	postion_to_reach = ((get_parent().get_node("YSort").get_node("Left").current_player.position.x +60) *1.1)-self.position.x * delta;
	self.position.x = self.position.x + ((postion_to_reach-self.position.x) * 0.1)

extends CanvasLayer


var left_node_path = "../YSort/Left"
onready var left_team = get_node(left_node_path)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("health_label").text = "health: "+  str(left_team.current_player.health)

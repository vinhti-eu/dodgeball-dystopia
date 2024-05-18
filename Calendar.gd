extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var helper = $"../CalendarHelper"
	highlight_curr_day(helper)


func highlight_curr_day(helper):
	var day = helper.get_curr_weekday()
	get_child(day -1).text = "YOOO PLS WORK"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

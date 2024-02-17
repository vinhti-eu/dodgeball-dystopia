extends Node2D

export var y_ratio = 0.8
export var left_center = Vector2(186, 168)
export var left_upleft = Vector2(125, 145)
export var left_downleft = Vector2(119, 197)
export var left_upright = Vector2(259, 145)
export var left_downright = Vector2(259, 197)


export var right_center = Vector2(390, 168)
export var right_upleft = Vector2(451, 145)
export var right_downleft = Vector2(457, 197)
export var right_upright = Vector2(325, 145)
export var right_downright = Vector2(325, 197)

export var left_spy = Vector2(505, 145)
export var right_spy = Vector2(70, 145)


var positions_array =  [left_upleft,left_upright, left_downleft, left_downright]

var positions_array2 = [right_upleft, right_upright, right_downleft, right_downright]


var debug_mode = false;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal got_ball(team, true)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	if(debug_mode):
		var point_color = Color(1, 0, 1) # Magenta

		draw_circle(left_center, 5, point_color)
		draw_circle(left_upleft, 5, point_color)
		draw_circle(left_downleft, 5, point_color)
		draw_circle(left_upright, 5, point_color)
		draw_circle(left_downright, 5, point_color)





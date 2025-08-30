extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var texture_health_line = ResourceLoader.load("res://healthbar_line.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
#	pass
func _draw():
	#50 shoud be last line
	if(get_parent().max_health !=null):
		var divider = 53/(get_parent().max_health/4 )
		for n in range( 1,52): # do not draw last line
			if(n % divider == 0):
				draw_texture(texture_health_line, Vector2(n,0))

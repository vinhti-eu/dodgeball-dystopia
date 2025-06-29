extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var moving
var y_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	self.y_pos = get_parent().global_position.y
	print("am I in")
	self.show()
	self.add_color_override("default_color","fc0000")
	moving = true
	var timer = Timer.new()
	timer.set_wait_time(0.5)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "_remove_self")
	add_child(timer)
	timer.start()
	y_pos = get_parent().global_position.y


	pass # Replace with function body.




var damping = 10.0  # Controls smoothing strength

func _process(delta):
	if moving:

		y_pos += (-0.01 - y_pos) * (1.0 - exp(-damping * delta))
		get_parent().global_position.y = y_pos

	#if (moving):
	#	get_parent().global_position = get_parent().global_position + Vector2(1,-1)

	
func _remove_self():
	print("REMOVE COME ONNN")
	self.hide()
	self.queue_free()
	
#	pass



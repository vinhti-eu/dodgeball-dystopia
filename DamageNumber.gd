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
	self.add_color_override("default_color","eff1f4")
	moving = true
	var timer = Timer.new()
	timer.set_wait_time(0.5)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "_remove_self")
	add_child(timer)
	timer.start()
	y_pos = get_parent().global_position.y
	#x_offset = get_parent().global_position.x


	pass # Replace with function body.




var increase_y = 4      # Initial vertical speed
#var x_offset = 0        # Base X position (set in _ready)
#var time_passed = 0.0   # Time accumulator for sine motion





func _process(delta):
	if moving:
		# Vertical easing
		get_parent().global_position.y -= increase_y
		increase_y *= 0.9  # decay over time

		

		# Horizontal sine wave
		#time_passed += delta
		#var sine_wave = sin(time_passed * 10.0) * increase_y *2#scale with y
		#et_parent().global_position.x = x_offset + sine_wave
	#if (moving):
	#	get_parent().global_position = get_parent().global_position + Vector2(1,-1)

	
func _remove_self():
	print("REMOVE COME ONNN")
	self.hide()
	self.queue_free()
	
#	pass



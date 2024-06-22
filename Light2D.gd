extends Light2D

# Declare the necessary variables

var speed = 0.5
var amplitude = 0.1
var base_energy = 0.6
var time_passed = 0.0

func _process(delta):
	# Update the time passed
	time_passed += delta
	
	# Calculate the new energy value using a sinusoidal function
	energy = base_energy + amplitude * sin(time_passed * speed * TAU)
	
	# Apply the calculated energy to the light's energy property
	self.energy = energy

		

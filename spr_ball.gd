extends Sprite

# script to change ball appearance and shaders depending on throw type
# needs shader material for further functionality
var x_scale = 1
var y_scale = 1
var normal_speed = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(get_parent().get_parent().jumping):
		self.scale.x = 1 + ( get_parent().get_parent().speed* 0.00025) -  (get_parent().get_parent().z_velocity) * 0.1
		scale.y = 1/scale.x
	else:
		scale.x = 1
		scale.y = 1

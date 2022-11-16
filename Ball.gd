extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var attached_to = null
var direction = null
var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(attached_to != null):
		self.position = attached_to.position
	if(direction != null):
		move_and_slide(direction * speed)

func attach(var person):
	attached_to = person
	
func throw(var vector, var speed_multiplyer):
	detach()	
	direction = vector * speed_multiplyer
	
func detach():
	attached_to = null	

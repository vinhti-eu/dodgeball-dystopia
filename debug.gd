extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var side_text = ""
var left_tactics = ""
var right_tactics = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		self.text = str(Engine.get_frames_per_second())
		self.text = self.text + "\n" + "ballside: " + side_text 
		self.text = self.text + "\n" + "ttl: " + left_tactics
		self.text = self.text + "\n" + "ttr: " + right_tactics

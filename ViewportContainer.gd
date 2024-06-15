extends ViewportContainer

func _ready():
	# Set the Camera2D as the current camera
	$Viewport.get_node("CanvasLayer/Arena/Camera").current = true

	# Connect the camera's transform_changed signal to update the viewport
	$Viewport.get_node("CanvasLayer/Arena/Camera").connect("transform_updated", self, "_on_camera_transform_changed")

func _on_camera_transform_changed():
	# Update the viewport position to match the camera's position
	rect_position.x = $Viewport.get_node("CanvasLayer/Arena/Camera").global_position.x * - 0.5

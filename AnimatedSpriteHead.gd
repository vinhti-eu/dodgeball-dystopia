extends AnimatedSprite

# Declare member variables
var sprite_folder = "res://sprites/player_sprites/temp/"
var head_sprite = "P1_head_0.png"

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_texture: Texture = load(sprite_folder + head_sprite)
	swap_textures(new_texture)

func swap_textures(p_texture: Texture) -> void:
	for anim_name in frames.get_animation_names():
		for i in range(frames.get_frame_count(anim_name)):
			var frame = frames.get_frame(anim_name, i)
			if frame is AtlasTexture:
				var atlas_texture: AtlasTexture = frame
				atlas_texture.atlas = p_texture
			else:
				print("Frame is not an AtlasTexture. Skipping.")

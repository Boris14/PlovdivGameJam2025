class_name BubbleTypeWidget
extends Control

enum EWidgetState
{
	Enabled,
	Disabled,
	Locked
}

@export var bubble_texture : Texture2D

var state : EWidgetState

func _ready():
	$EnabledImage.texture = bubble_texture
	$DisabledImage.texture = convert_to_grayscale(bubble_texture)
	set_state(EWidgetState.Disabled)

func set_state(new_state: EWidgetState):
	match(new_state):
		EWidgetState.Enabled:
			$DisabledImage.visible = false
			$LockedImage.visible = false
			$EnabledImage.visible = true
		EWidgetState.Disabled:
			$DisabledImage.visible = true
			$LockedImage.visible = false
			$EnabledImage.visible = false
		EWidgetState.Locked:
			$DisabledImage.visible = false
			$LockedImage.visible = false
			$EnabledImage.visible = false
			
func convert_to_grayscale(texture: Texture2D) -> Texture2D:
	var image = texture.get_image()

	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var color = image.get_pixel(x, y)
			var gray_value = 0.299 * color.r + 0.587 * color.g + 0.114 * color.b
			image.set_pixel(x, y, Color(gray_value, gray_value, gray_value, color.a))
		
	return ImageTexture.create_from_image(image)

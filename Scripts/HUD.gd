class_name HUD
extends Control

var bubble_type_widgets : Array[BubbleTypeWidget]

func _ready():
	for child in %BubbleTypeContainer.get_children():
		bubble_type_widgets.append(child)
	
func set_bubble_type(new_type, unlocked_bubble_types):
	for bubble_widget in bubble_type_widgets:
		bubble_widget.set_state(BubbleTypeWidget.EWidgetState.Locked)
	for type in unlocked_bubble_types:
		bubble_type_widgets[type].set_state(BubbleTypeWidget.EWidgetState.Disabled)
	bubble_type_widgets[new_type].set_state(BubbleTypeWidget.EWidgetState.Enabled)

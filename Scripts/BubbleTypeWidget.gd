class_name BubbleTypeWidget
extends Control

enum EWidgetState
{
	Enabled,
	Disabled,
	Locked
}

var state : EWidgetState

func _ready():
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
			$LockedImage.visible = true
			$EnabledImage.visible = false

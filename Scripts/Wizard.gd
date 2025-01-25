class_name Wizard
extends CharacterBody2D

@export var bubble_scene : PackedScene = preload("res://Scenes/Bubble.tscn")
@export var needle_scene : PackedScene = preload("res://Scenes/Needle.tscn")
@export var follow_speed := 10.0

func _ready():
	pass
	
func _physics_process(delta):
	var target_y = get_global_mouse_position().y
	global_position.y = lerp(
		global_position.y, 
		target_y, 
		follow_speed * delta
	)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				var bubble = bubble_scene.instantiate()
				bubble.global_position = $BubbleSpawn.global_position
				get_tree().current_scene.add_child(bubble)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				var needle = needle_scene.instantiate()
				needle.global_position = $BubbleSpawn.global_position
				get_tree().current_scene.add_child(needle)

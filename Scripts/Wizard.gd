class_name Wizard
extends CharacterBody2D

@export var bubble_scene : PackedScene = preload("res://Scenes/Bubble.tscn")
@export var needle_scene : PackedScene = preload("res://Scenes/Needle.tscn")
@export var follow_speed := 8.0
@export var bubble_cooldown := 1.0
@export var needle_cooldown := 0.5

var can_spawn_bubble := true
var can_spawn_needle := true

func _ready():
	pass
	
func _physics_process(delta):
	var target_y = get_global_mouse_position().y
	global_position.y = lerp(
		global_position.y, 
		target_y, 
		follow_speed * delta
	)
	
func spawn_bubble(pos):
	var bubble = bubble_scene.instantiate()
	bubble.global_position = $BubbleSpawn.global_position
	get_tree().current_scene.add_child(bubble)
	
func spawn_needle(pos):
	var needle = needle_scene.instantiate()
	needle.global_position = $BubbleSpawn.global_position
	get_tree().current_scene.add_child(needle)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				spawn_bubble($BubbleSpawn.global_position)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				spawn_needle($BubbleSpawn.global_position)

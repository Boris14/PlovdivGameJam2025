class_name Wizard
extends CharacterBody2D

@export var bubble_scene : PackedScene = preload("res://Scenes/Bubble.tscn")
@export var needle_scene : PackedScene = preload("res://Scenes/Needle.tscn")
@export var follow_speed := 200.0
@export var bubble_cooldown := 1.0
@export var needle_cooldown := 0.5
@export var trail_duration: float = 0.5  # Trail duration in seconds
@export var trail_start_color: Color = Color.WHITE
@export var trail_width: float = 3.0

var position_history: Array[Dictionary] = []

var can_spawn_bubble := true
var can_spawn_needle := true

func _ready():
	floor_stop_on_slope = false
	floor_snap_length = 0.0
	
	# Alternatively, set floor_max_angle to 0 to prevent any slope interaction
	floor_max_angle = 0.0
	
func _physics_process(delta):
	var target_y = get_global_mouse_position().y
	velocity.y = (target_y - global_position.y) * follow_speed * delta
	
	# Store current position with timestamp
	position_history.push_front({
		"position": global_position,
		"timestamp": Time.get_ticks_msec()
	})
	
	# Remove positions older than trail_duration
	var current_time = Time.get_ticks_msec()
	position_history = position_history.filter(func(entry):
		return (current_time - entry.timestamp) / 1000.0 <= trail_duration
	)
	
	# Move the  character
	move_and_slide()
	queue_redraw()
	
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

func _draw():
	if position_history.size() > 1:
		var current_time = Time.get_ticks_msec()
		
		for i in range(1, position_history.size()):
			var start = position_history[i-1]
			var end = position_history[i]
			
			# Calculate fade based on time difference
			var time_diff = current_time - start.timestamp
			var alpha = max(0, 1.0 - (time_diff / (trail_duration * 1000.0)))
			
			var fade_color = trail_start_color
			fade_color.a = alpha
			
			draw_line(
				to_local(start.position),
				to_local(end.position),
				fade_color,
				trail_width
			)

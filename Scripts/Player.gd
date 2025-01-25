class_name Player
extends CharacterBody2D

@export var speed: float = 80.0  # Horizontal movement speed
@export var gravity: float = 300.0  # Gravity strength in pixels/second²
@export var trail_duration: float = 1  # Trail duration in seconds
@export var trail_start_color: Color = Color.WHITE
@export var trail_width: float = 2.0

var is_bubbled := false

func _physics_process(delta: float) -> void:
	if not is_bubbled:
		velocity.x = speed
		velocity.y += gravity * delta
	
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
	
func on_bubbled():
	is_bubbled = true
	
func on_bubble_popped():
	is_bubbled = false

var position_history: Array[Dictionary] = []

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

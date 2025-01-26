class_name Needle
extends Area2D

@export var speed: float = 700.0 
var collision_processed: bool = false
@onready var bubble_pop_sfx: AudioStreamPlayer = $SFX/BubblePopSfx
@onready var needle_hit_sfx: AudioStreamPlayer = $SFX/NeedleHitSfx
@export var trail_duration: float = 0.2  # Trail duration in seconds
@export var trail_start_color: Color = Color.WHITE
@export var trail_width: float = 5.0

var position_history: Array[Dictionary] = []

func _ready():
	body_entered.connect(_on_body_entered)
	
func _physics_process(delta):
	if not monitoring:
		return 
	
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
	queue_redraw()
			
	position.x += speed * delta
	
func _on_body_entered(body):
	if collision_processed:
		return
	
	collision_processed = true
	
	if body is Bubble:
		hit()
	elif body is Player:
		body.call_deferred("die")
		hit()
	elif body.is_in_group("boss"):
		body.take_damage()
		hit()

func hit():
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
	needle_hit_sfx.play()
	await get_tree().create_timer(0.2).timeout
	call_deferred("queue_free")

func _draw():
	if $Sprite2D.visible and position_history.size() > 1:
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

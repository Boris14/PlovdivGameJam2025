class_name BubblePath
extends Path2D

@onready var path_follow : PathFollow2D = $PathFollow2D
@export var dash_length: float = 10.0
@export var gap_length: float = 20.0
@export var line_color: Color = Color.WHITE
@export var line_width: float = 2.0
@export var is_reversed:= false

signal on_finished()

func _ready():
	path_follow.loop = false
	if is_reversed:
		path_follow.progress_ratio = 1

func move(delta_progress: float) -> Vector2:
	var new_position
	if not is_reversed: 
		path_follow.progress += delta_progress
		new_position = path_follow.global_position
		if path_follow.progress_ratio >= 1:
			on_finished.emit()
			queue_free()
	else:
		path_follow.progress -= delta_progress
		new_position = path_follow.global_position
		if path_follow.progress_ratio <= 0:
			on_finished.emit()
			queue_free()
	return new_position
	
func _draw():
	pass
	#var baked_points = curve.get_baked_points()
	#
	#for i in range(1, baked_points.size()):
	#	var current_pos = baked_points[i-1]
	#	var end_pos = baked_points[i]
	#	
	#	var line_vector = end_pos - current_pos
	#	var line_length = line_vector.length()
	#	var line_direction = line_vector.normalized()
	#	
	#	var distance = 0.0
	#	var is_dash = true
	#	
	#	while distance < line_length:
	#		var segment_length = dash_length if is_dash else gap_length
	#		segment_length = min(segment_length, line_length - distance)
	#		
	#		if is_dash:
	#			draw_line(
	#				current_pos + line_direction * distance, 
	#				current_pos + line_direction * (distance + segment_length), 
	#				line_color, 
	#				line_width
	#			)
	#		
	#		distance += segment_length
	#		is_dash = !is_dash
	##draw_polyline(curve.get_baked_points(), Color.AQUA)
#

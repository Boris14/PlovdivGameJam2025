class_name BubblePath
extends Path2D

@onready var path_follow : PathFollow2D = $PathFollow2D

signal on_finished()

func _ready():
	path_follow.loop = false

func move(delta_progress: float) -> Vector2:
	if path_follow.progress_ratio < 1:
		path_follow.progress += delta_progress
	else:
		on_finished.emit()
	return path_follow.global_position

class_name MovableObject
extends Node2D

var swallow_speed := 20

@export var path : PathFollow2D
@export var speed := 200
@export var origin : Node2D

var direction := 1

func _ready():
	if path != null:
		path.loop = false
		path.global_position = global_position

func on_bubbled(bubble : Bubble):
	bubble.swallow_speed = swallow_speed
	
func on_bubble_popped():
	if origin != null:
		origin.global_position = global_position
	
func _physics_process(delta):
	if path == null:
		return
	global_position = path.global_position
	path.progress += speed * delta * direction
	if path.progress_ratio >= 1 and direction > 0:
		direction = -1
	elif path.progress_ratio <= 0 and direction < 0:
		direction = 1

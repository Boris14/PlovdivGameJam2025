class_name MovingPlatfrom
extends AnimatableBody2D

@export var speed := 100.0
@export var patrol_dist := 250

var direction := 1
var initial_pos : Vector2

func _ready():
	initial_pos = global_position
	
func _physics_process(delta):
	global_position.x += speed * delta * direction
	var delta_pos = global_position.x - initial_pos.x
	if delta_pos > patrol_dist and direction > 0:
		direction = -1
	elif delta_pos < -patrol_dist and direction < 0:
		direction = 1

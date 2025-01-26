class_name FlyingEnemy
extends Area2D

var swallow_speed := 20

@export var radius: float = 200.0  # Size of the infinity shape
@export var speed: float = 1.0     # Movement speed

var bubble = null
var initial_position: Vector2
var time: float = 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	initial_position = global_position

func _process(delta):
	if bubble != null:
		return
	time += delta * speed
	# Parametric equations for infinity shape
	var x = initial_position.x + radius * cos(time + PI/2)
	var y = initial_position.y + radius * sin(time) * cos(time)
	
	global_position = Vector2(x, y)

func on_bubbled(in_bubble : Bubble):
	bubble = in_bubble
	bubble.swallow_speed = swallow_speed
	
func on_bubble_popped():
	bubble = null
	time = 0
	initial_position = global_position
	
func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		body.call_deferred("die")
	elif body is Bubble:
		body.pop()

class_name Needle
extends Area2D

@export var speed: float = 500.0 
var collision_processed: bool = false
@onready var bubble_pop_sfx: AudioStreamPlayer = $SFX/BubblePopSfx

func _ready():
	body_entered.connect(_on_body_entered)
	
func _physics_process(delta):
	if not monitoring:
		return 
			
	position.x += speed * delta
	
func _on_body_entered(body):
	if collision_processed:
		return
	
	collision_processed = true
	
	if body is Bubble:
		body.pop()
		call_deferred("queue_free")
	elif body is Player:
		body.call_deferred("die")
		call_deferred("queue_free")

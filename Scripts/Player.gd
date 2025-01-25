class_name Player
extends CharacterBody2D

@export var speed: float = 80.0  # Horizontal movement speed
@export var gravity: float = 300.0  # Gravity strength in pixels/second²

var is_bubbled := false

func _physics_process(delta: float) -> void:
	if not is_bubbled:
		velocity.x = speed
		velocity.y += gravity * delta
	
	# Move the  character
	move_and_slide()
	
func on_bubbled():
	is_bubbled = true
	
func on_bubble_popped():
	is_bubbled = false

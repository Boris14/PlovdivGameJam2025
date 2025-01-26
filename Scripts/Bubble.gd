class_name Bubble
extends AnimatableBody2D

@export var initial_speed: float = 200.0  # Horizontal movement speed
@export var carry_speed: float = 120.0
@export var path_scene: PackedScene
@onready var bubble_pop_sfx: AudioStreamPlayer = $SFX/BubblePopSfx

var swallow_speed := 50.0
var full_swallow_treshold := 10
var velocity := Vector2.ZERO
var controlled_body: PhysicsBody2D
var path: BubblePath
var is_swallowing := false

func _ready():
	%Area2D.body_entered.connect(_on_body_entered)
	velocity.x = initial_speed

func _physics_process(delta: float) -> void:
	if controlled_body != null and controlled_body.is_queued_for_deletion():
		controlled_body = null
		
	if controlled_body != null:
		if is_swallowing:
			controlled_body.global_position = controlled_body.global_position.lerp(global_position, delta * swallow_speed)
		else:
			controlled_body.global_position = global_position
			
		if controlled_body.global_position.distance_to(global_position) <= full_swallow_treshold:
			is_swallowing = false
		if path:
			global_position = path.move(carry_speed * delta)
	else:
		position = position + velocity * delta

func _on_body_entered(body):    
	if body.is_in_group("bubbleable"):
		bubble(body)
	elif controlled_body != null:
		pop()

func _on_path_finished():
	pop()

func bubble(body):
	path = path_scene.instantiate() as BubblePath
	path.on_finished.connect(_on_path_finished)
	get_tree().current_scene.add_child(path)
	path.global_position = global_position
	
	if body.has_method("on_bubbled"):
		body.on_bubbled(self)
		controlled_body = body
		is_swallowing = true

func pop():
	bubble_pop_sfx.play()
	if controlled_body and not controlled_body.is_queued_for_deletion() and controlled_body.has_method("on_bubble_popped"):
		controlled_body.on_bubble_popped()
	queue_free()

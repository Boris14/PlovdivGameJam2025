class_name Bubble
extends AnimatableBody2D

@export var initial_speed: float = 200.0  # Horizontal movement speed
@export var carry_speed: float = 120.0
@export var path_scene: PackedScene

var velocity := Vector2.ZERO
var controlled_body: PhysicsBody2D
var path: BubblePath

func _ready():
	%Area2D.body_entered.connect(_on_body_entered)
	velocity.x = initial_speed

func _physics_process(delta: float) -> void:
	if controlled_body:
		controlled_body.position = position
		if path:
			global_position = path.move(carry_speed * delta)
	else:
		position = position + velocity * delta

func _on_body_entered(body):    
	if body.is_in_group("bubbleable"):
		bubble(body)

func _on_path_finished():
	pop()

func bubble(body):
	path = path_scene.instantiate() as BubblePath
	path.on_finished.connect(_on_path_finished)
	get_tree().root.add_child(path)
	path.global_position = global_position
	
	if body.has_method("on_bubbled"):
		body.on_bubbled()
		controlled_body = body
	
func pop():
	if controlled_body and controlled_body.has_method("on_bubble_popped"):
		controlled_body.on_bubble_popped()
	queue_free()

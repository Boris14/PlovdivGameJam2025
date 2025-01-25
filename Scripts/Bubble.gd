class_name Bubble
extends AnimatableBody2D

@export var initial_speed: float = 150.0  # Horizontal movement speed
@export var carry_speed: float = 50.0

var velocity := Vector2.ZERO
var controlled_body: PhysicsBody2D

func _ready():
	%Area2D.body_entered.connect(_on_body_entered)
	velocity.x = initial_speed

func _physics_process(delta: float) -> void:
	position = position + velocity * delta
	if controlled_body:
		controlled_body.position = position

func _on_body_entered(body):    
	if body.is_in_group("bubbleable"):
		if body.has_method("on_bubbled"):
			body.on_bubbled()
			velocity.x = carry_speed
			velocity.y = -carry_speed / 2
			controlled_body = body

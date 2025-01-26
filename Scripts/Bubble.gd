class_name Bubble
extends AnimatableBody2D

@export var initial_speed: float = 400.0  # Horizontal movement speed
@export var carry_speed: float = 120.0
@export var path_scene: PackedScene
@onready var pop_sound: AudioStream = preload("res://Audio/SFX/bubble_pop_sfx.ogg")
@onready var bubble_wrap_sfx: AudioStreamPlayer = $SFX/BubbleWrapSfx

var swallow_speed := 50.0
var full_swallow_treshold := 10
var velocity := Vector2.ZERO
var controlled_body: Node2D
var path: BubblePath
var is_swallowing := false

func _ready():
	%Area2D.body_entered.connect(_on_body_entered)
	%Area2D.area_entered.connect(_on_area_entered)
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
	if body.is_in_group("wizard"):
		return
	if controlled_body != null:
		pop()	
	elif body.is_in_group("bubbleable"):
		bubble(body)

func _on_area_entered(area):  
	if area.is_in_group("wizard"):
		return
	if area is Needle:
		area.hit()
		pop()
	elif controlled_body != null:
		pop()
	elif area.is_in_group("bubbleable"):
		bubble(area)

func _on_path_finished():
	pop()

func bubble(body):
	if controlled_body != null:
		return
	path = path_scene.instantiate() as BubblePath
	path.on_finished.connect(_on_path_finished)
	get_tree().current_scene.add_child(path)
	path.global_position = global_position
	
	if body.has_method("on_bubbled"):
		body.on_bubbled(self)
		controlled_body = body
		is_swallowing = true
		bubble_wrap_sfx.play()

func pop():
	if controlled_body and not controlled_body.is_queued_for_deletion() and controlled_body.has_method("on_bubble_popped"):
		controlled_body.on_bubble_popped()
	var pop_sfx = AudioStreamPlayer.new()
	pop_sfx.stream = pop_sound
	get_tree().current_scene.add_child(pop_sfx)
	pop_sfx.play()
	queue_free()

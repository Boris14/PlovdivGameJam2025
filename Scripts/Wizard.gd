class_name Wizard
extends CharacterBody2D

enum EBubbleType
{
	Normal,
	Spiral,
	Back
}

@export var normal_bubble_scene : PackedScene = preload("res://Scenes/Bubbles/BubbleNormal.tscn")
@export var spiral_bubble_scene : PackedScene = preload("res://Scenes/Bubbles/BubbleSpiral.tscn")
@export var back_bubble_scene : PackedScene = preload("res://Scenes/Bubbles/BubbleBack.tscn")

@export var needle_scene : PackedScene = preload("res://Scenes/Needle.tscn")
@export var follow_speed := 200.0
@export var bubble_cooldown := 1.0
@export var needle_cooldown := 0.5
@export var trail_duration: float = 0.5  # Trail duration in seconds
@export var trail_start_color: Color = Color.WHITE
@export var trail_width: float = 3.0
@export var min_y := 250.0
@export var max_y := 1000.0

@onready var bubble_launch_sfx: AudioStreamPlayer = $SFX/BubbleLaunchSfx
@onready var needle_launch_sfx: AudioStreamPlayer = $SFX/NeedleLaunchSfx
@onready var animation_player = $Sprite2D/AnimationPlayer
@onready var ui_switch_sfx = $SFX/UiSwitchSfx
@onready var wizzard_teleport_sfx = $SFX/WizzardTeleportSfx

var position_history: Array[Dictionary] = []

var unlocked_bubble_types: Array[EBubbleType] = [EBubbleType.Normal, EBubbleType.Spiral, EBubbleType.Back]
var curr_bubble_type := EBubbleType.Normal

var change_type_delay := 0.1
var stop := false

var can_spawn_bubble := true
var can_spawn_needle := true
var can_change_type := true

signal bubble_type_changed(new_type : EBubbleType, unlocked_types : Array[EBubbleType])

func _ready():
	floor_stop_on_slope = false
	floor_snap_length = 0.0
	floor_max_angle = 0.0
	set_bubble_type(EBubbleType.Normal)
	animation_player.animation_finished.connect(_on_appear_animation_finished)
	animation_player.speed_scale = 1.5
	animation_player.play("appear")
	wizzard_teleport_sfx.play()
	
func _on_appear_animation_finished(_anim_name : String):
	animation_player.disconnect("animation_finished", _on_appear_animation_finished)
	animation_player.play("idle")

func _physics_process(delta):
	if stop:
		return
	var target_y = get_global_mouse_position().y + 50
	target_y = clamp(target_y, min_y, max_y)
	velocity.y = (target_y - global_position.y) * follow_speed * delta
	
	# Store current position with timestamp
	position_history.push_front({
		"position": global_position,
		"timestamp": Time.get_ticks_msec()
	})
	
	# Remove positions older than trail_duration
	var current_time = Time.get_ticks_msec()
	position_history = position_history.filter(func(entry):
		return (current_time - entry.timestamp) / 1000.0 <= trail_duration
	)
	
	# Move the  character
	move_and_slide()
	queue_redraw()
	
func spawn_bubble(pos):
	if not can_spawn_bubble or stop:
		return
	var bubble
	match(curr_bubble_type):
		EBubbleType.Normal:
			bubble = normal_bubble_scene.instantiate()
		EBubbleType.Spiral:
			bubble = spiral_bubble_scene.instantiate()
		EBubbleType.Back:
			bubble = back_bubble_scene.instantiate()
		_:
			return
	bubble.global_position = pos
	get_tree().current_scene.add_child(bubble)
	bubble_launch_sfx.play()
	can_spawn_bubble = false
	for body in $NeedleCheckArea.get_overlapping_bodies():
		if body.name == "Roof":
			bubble.pop(true)
	await get_tree().create_timer(bubble_cooldown).timeout
	can_spawn_bubble = true
	
func spawn_needle(pos):
	if not can_spawn_needle or stop:
		return
	for body in $NeedleCheckArea.get_overlapping_bodies():
		if body is Bubble:
			body.pop(true)
			return
			
	var needle = needle_scene.instantiate()
	needle.global_position = pos
	get_tree().current_scene.add_child(needle)
	needle_launch_sfx.play()
	can_spawn_needle = false
	await get_tree().create_timer(needle_cooldown).timeout
	can_spawn_needle = true

func set_bubble_type(new_type : EBubbleType):
	curr_bubble_type = new_type
	bubble_type_changed.emit(new_type, unlocked_bubble_types)
	can_change_type = false
	ui_switch_sfx.play()
	await get_tree().create_timer(change_type_delay).timeout
	can_change_type = true

func teleport():
	stop = true
	animation_player.play_backwards("appear")

func _input(event):
	if stop:
		return
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				spawn_bubble($BubbleSpawn.global_position)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				spawn_needle($BubbleSpawn.global_position)
	
	if can_change_type and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			var current_type_index = unlocked_bubble_types.find(curr_bubble_type)
			var new_index = current_type_index - 1 if current_type_index > 0 else unlocked_bubble_types.size() - 1
			set_bubble_type(unlocked_bubble_types[new_index])
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var current_type_index = unlocked_bubble_types.find(curr_bubble_type)
			var new_index = current_type_index + 1 if current_type_index < unlocked_bubble_types.size() - 1 else 0
			set_bubble_type(unlocked_bubble_types[new_index])

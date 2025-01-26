class_name Boss
extends Area2D

@onready var noraml_sprite = $Normal
@onready var damaged_sprite = $Damaged
@export var damaged_duration := 0.2
@export var health := 10
@export var needle_scene : PackedScene
@export var shoot_delay := 2.5

var shoot_positions : Array[Node2D]
var shoot_timer : Timer

signal win_game

func _ready():
	for child in $ShootPositions.get_children():
		shoot_positions.append(child)
	shoot_timer = Timer.new()
	shoot_timer.timeout.connect(shoot)
	shoot_timer.wait_time = shoot_delay 
	add_child(shoot_timer)
	shoot_timer.start()
	
	noraml_sprite.visible = true
	damaged_sprite.visible = false
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area is Needle and not area.is_in_group("Boss"):
		take_damage()
		area.hit()
		
func _on_body_entered(body):
	if body is Player:
		body.die()

func shoot():
	var needle = needle_scene.instantiate() as Needle
	needle.global_position = shoot_positions.pick_random().global_position
	needle.direction = -1
	get_tree().current_scene.add_child(needle)
	$NeedleLaunchSfx.play()

func take_damage():
	if health <= 0:
		return 
		
	noraml_sprite.visible = false
	damaged_sprite.visible = true
	
	health -= 1
	if health <= 0:
		shoot_timer.stop()
		win_game.emit()
		return
		
	# Use a timer to switch back
	var timer = get_tree().create_timer(damaged_duration)
	timer.timeout.connect(reset_sprites)

func reset_sprites():
	noraml_sprite.visible = true
	damaged_sprite.visible = false

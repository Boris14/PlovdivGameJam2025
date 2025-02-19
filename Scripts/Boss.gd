class_name Boss
extends Area2D

@onready var noraml_sprite = $Normal
@onready var damaged_sprite = $Damaged
@onready var animation_player := $AnimationPlayer as AnimationPlayer
@export var damaged_duration := 0.2
@export var health := 10
@export var needle_scene : PackedScene
@export var shoot_delay := 2.5
@export var fade_out_duration := 1.5

var shoot_positions : Array[Node2D]
var shoot_timer : Timer
var telegraph_shot_timer : Timer
var is_fading_out := false

signal win_game

func _ready():
	for child in $ShootPositions.get_children():
		shoot_positions.append(child)
		
	$ShootPositions/ShootPosition1/ShootUpSprite.visible = false
	$ShootPositions/ShootPosition2/ShootMiddleSprite.visible = false
	$ShootPositions/ShootPosition3/ShootDownSprite.visible = false
		
	telegraph_shot_timer = Timer.new()
	telegraph_shot_timer.wait_time = shoot_delay
	telegraph_shot_timer.timeout.connect(telegraph_shot)
	telegraph_shot_timer.one_shot = true
	add_child(telegraph_shot_timer)
	telegraph_shot_timer.start()
	
	shoot_timer = Timer.new()
	shoot_timer.one_shot = true
	add_child(shoot_timer)
	
	noraml_sprite.visible = true
	damaged_sprite.visible = false
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _on_area_entered(area):
	if area is Needle and not area.is_in_group("Boss"):
		take_damage()
		area.hit()
		
func _on_body_entered(body):
	if body is Player:
		body.die()

func telegraph_shot():
	var position_index = randi_range(0, shoot_positions.size() - 1)
	var animation_name : String
	match(position_index):
		0:
			animation_name = "ShootUp"
		1:
			animation_name = "ShootMiddle"
		2:
			animation_name = "ShootDown"
	
	shoot_timer.timeout.connect(shoot.bind(shoot_positions[position_index].global_position))
	shoot_timer.wait_time = animation_player.get_animation(animation_name).length
	animation_player.play(animation_name)
	shoot_timer.start()


func shoot(pos):
	for binding in shoot_timer.timeout.get_connections():
		shoot_timer.timeout.disconnect(binding.callable)
	
	var needle = needle_scene.instantiate() as Needle
	needle.global_position = pos
	needle.direction = -1
	get_tree().current_scene.add_child(needle)
	$NeedleLaunchSfx.play()
	telegraph_shot_timer.start()

func take_damage():
	if health <= 0:
		return 
		
	noraml_sprite.visible = false
	damaged_sprite.visible = true
	
	health -= 1
	if health <= 0:
		$ShootPositions/ShootPosition1/ShootUpSprite.visible = false
		$ShootPositions/ShootPosition2/ShootMiddleSprite.visible = false
		$ShootPositions/ShootPosition3/ShootDownSprite.visible = false
		telegraph_shot_timer.stop()
		shoot_timer.stop()
		is_fading_out = true
		return
		
	# Use a timer to switch back
	var timer = get_tree().create_timer(damaged_duration)
	timer.timeout.connect(reset_sprites)

func _process(delta):
	if is_fading_out:
		modulate.a -= delta * (1 / fade_out_duration)
		if modulate.a <= 0:
			win_game.emit()

func reset_sprites():
	noraml_sprite.visible = true
	damaged_sprite.visible = false

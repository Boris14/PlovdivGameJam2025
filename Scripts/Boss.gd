class_name Boss
extends Area2D

@onready var noraml_sprite = $Normal
@onready var damaged_sprite = $Damaged
@export var damaged_duration := 0.2
@export var health := 10

signal win_game

func _ready():
	noraml_sprite.visible = true
	damaged_sprite.visible = false
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area is Needle:
		take_damage()
		area.hit()

func take_damage():
	if health <= 0:
		return 
		
	noraml_sprite.visible = false
	damaged_sprite.visible = true
	
	health -= 1
	if health <= 0:
		win_game.emit()
		return
		
	# Use a timer to switch back
	var timer = get_tree().create_timer(damaged_duration)
	timer.timeout.connect(reset_sprites)

func reset_sprites():
	noraml_sprite.visible = true
	damaged_sprite.visible = false

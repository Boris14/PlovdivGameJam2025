class_name Game
extends Node2D

@export var player_scene : PackedScene = preload("res://Scenes/Player.tscn")
@export var wizard_scene : PackedScene = preload("res://Scenes/Wizard.tscn")
@export var wizard_x_offset := 50
@export var start_delay := 1.5

func _ready():
	var player = player_scene.instantiate() as Player
	player.died.connect(_on_player_died)
	player.position = %PlayerStart.position
	add_child(player)
	
	await get_tree().create_timer(start_delay).timeout
	
	var wizard = wizard_scene.instantiate() as Wizard
	wizard.global_position.y = get_global_mouse_position().y
	wizard.global_position.x = wizard_x_offset
	add_child(wizard)
	
func _on_player_died():
	get_tree().reload_current_scene()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

class_name Game
extends Node2D

@export var player_scene : PackedScene = preload("res://Scenes/Player.tscn")
@export var wizard_scene : PackedScene = preload("res://Scenes/Wizard.tscn")
@export var wizard_x_offset := 10

func _ready():
	var player = player_scene.instantiate() as Player
	player.died.connect(_on_player_died)
	player.position = %PlayerStart.position
	add_child(player)
	
	var wizard = wizard_scene.instantiate() as Wizard
	wizard.global_position.y = get_global_mouse_position().y
	wizard.global_position.x = wizard_x_offset
	add_child(wizard)
	
func _on_player_died():
	get_tree().reload_current_scene()

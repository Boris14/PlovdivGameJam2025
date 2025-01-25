class_name Game
extends Node2D

@export var bubble_scene : PackedScene
@export var player_scene : PackedScene

func _ready():
	var player = player_scene.instantiate()
	player.position = %PlayerStart.position
	add_child(player)
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var bubble = bubble_scene.instantiate()
			bubble.position.x = -50
			bubble.position.y = event.position.y
			add_child(bubble)

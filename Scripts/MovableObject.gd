class_name MovableObject
extends Node2D

var swallow_speed := 20

func on_bubbled(bubble : Bubble):
	bubble.swallow_speed = swallow_speed
	
func on_bubble_popped():
	pass

extends Node


var horizontal = 0.0
var vertical = 0.0

export(float) var acceleration = 4
export(float) var damping_factor = 0.9

signal click
signal T_press

func pressing_any_button():
	return abs(horizontal) > 0.25 or abs(vertical) > 0.25

func _process(delta):
	#Axies
	horizontal += (-1 if Input.is_action_pressed("Left") else 0)*delta*acceleration
	horizontal += (1 if Input.is_action_pressed("Right") else 0)*delta*acceleration
	
	vertical += (-1 if Input.is_action_pressed("Down") else 0)*delta*acceleration
	vertical += (1 if Input.is_action_pressed("Up") else 0)*delta*acceleration
	
	#desacceleration
	if not Input.is_action_pressed("Left") and not Input.is_action_pressed("Right"):
		horizontal *= damping_factor
	if not Input.is_action_pressed("Down") and not Input.is_action_pressed("Up"):
		vertical *= damping_factor
	horizontal = clamp(horizontal,-1,1)
	vertical = clamp(vertical,-1,1)
	
	#actions
	if Input.is_action_just_pressed("LeftClick"):
		emit_signal("click")
	if Input.is_action_just_pressed("T"):
		emit_signal("T_press")

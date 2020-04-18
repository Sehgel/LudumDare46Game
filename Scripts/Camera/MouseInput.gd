extends Node

var mouse_axis = Vector2.ZERO
export(float) var acceleration = 4
export(float) var damping_factor = 0.9

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_delta = event.relative/100.0
		mouse_axis += mouse_delta*get_process_delta_time()*acceleration
		

func _process(delta):
	
	#desacceleration
	mouse_axis *= damping_factor
		
	mouse_axis.x = clamp(mouse_axis.x,-1,1)
	mouse_axis.y = clamp(mouse_axis.y,-1,1)

	

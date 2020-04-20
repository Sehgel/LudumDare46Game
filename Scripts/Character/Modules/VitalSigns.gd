extends Node

export(float) var time = 10.0

var blood_level = 1.0
var lung_level = 1.0
var temperature_level = 0.5

var blood_reduction_factor = 1.0
var lung_reduction_factor = 1.0
var temperature_viriation_factor = 0.0

var updating = false
	
func _ready():
	Events.connect("on_game_start",self,"start")
	Events.connect("on_death",self,"death")
	Events.connect("on_tablet_taken",self,"on_bleed_buff_added")
	Events.connect("on_tablet_disipated",self,"on_bleed_buff_disipated")
	
func on_bleed_buff_added():
	blood_reduction_factor /= 2
func on_bleed_buff_disipated():
	blood_reduction_factor *= 2
	
	
func death():
	updating = false
	
func start():
	blood_level = 1.0
	lung_level = 1.0
	temperature_level = 0.5
	updating = true

func _process(delta):
	if updating:
		blood_level -= (get_process_delta_time()/time) * blood_reduction_factor
#		lung_level -= get_process_delta_time()/time * lung_reduction_factor
#		temperature_level += get_process_delta_time()/time * temperature_viriation_factor
#
		Events.emit_signal("on_blood_level_update",blood_level)
#		Events.emit_signal("on_lung_level_update",lung_level)
#		Events.emit_signal("on_temperature_level_update",temperature_level)
		
		if(blood_level <= 0.0 or lung_level <= 0.0 or temperature_level <= 0.0 or temperature_level >= 1.0):
			Events.emit_signal("on_death")
		

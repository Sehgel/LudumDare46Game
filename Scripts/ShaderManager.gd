extends Control


onready var whirl_buffer = $Whirl
onready var black_attenuation_buffer = $BlackAttenuation
onready var blur_buffer = $Blur
onready var black_out_buffer = $BlackOut
onready var trip_buffer = $Trip


onready var whirl_material = $Whirl/TextureRect.material
onready var black_attenuation_material = $BlackAttenuation/TextureRect2.material
onready var blur_material = $Blur/TextureRect2.material
onready var blackout_material = $BlackOut/TextureRect2.material

signal idle_frame

func _ready():
	Events.connect("on_pill_taken",self,"apply_pill_effects")
	Events.connect("on_tablet_taken",self,"apply_tablet_effects")
	Events.connect("on_syringe_applied",self,"apply_syringe_effects")
	Events.connect("on_death",self,"on_death")
	
	whirl_buffer.visible = false
	black_attenuation_buffer.visible = false
	blur_buffer.visible = false
	black_out_buffer.visible = false
	trip_buffer.visible = false
	
	whirl_material.set_shader_param("coeficient",0)
	black_attenuation_material.set_shader_param("coeficient",0)
	blur_material.set_shader_param("coeficient",0)
	blackout_material.set_shader_param("coeficient",0)


func on_death():
	black_out_buffer.visible = true
#	smooth_set_coeficient(blackout_material,1,1)
	var timer = Timer.new()
	add_child(timer)
	timer.start(3)
	yield(timer,"timeout")
	print(get_tree().reload_current_scene())
	Events.emit_signal("on_game_start")

func apply_pill_effects():
	play_effect("Blur",1,2,1.5)
	
func apply_tablet_effects():
	play_effect("Trip",1,2,1.5)
	
func apply_syringe_effects():
	play_effect("Whirl",1,2,1.5)

var effects= []
var disipated_effects = []
func play_effect(_name, effect, time, delay):
	var selected_material = null
	if _name == "Whirl":
		whirl_buffer.visible = true
		selected_material = whirl_buffer.get_child(0).material
	if _name == "Trip":
		trip_buffer.visible = true
		selected_material = trip_buffer.get_child(0).material
	if _name == "Blur":
		blur_buffer.visible = true
		selected_material = blur_buffer.get_child(0).material
	
	effects.append(Effect.new(_name, effect,time,delay,selected_material))

func disipate_effect(effect):
	effect.last_effect = effect.material.get_shader_param("coeficient")
	disipated_effects.append(effect)
	
func _process(delta):
	#DISIPATED EFFECTS
	for i in range(disipated_effects.size()-1,-1,-1):
		if disipated_effects[i].easeOut > 0:
			disipated_effects[i].easeOut -= delta
			var x = 1 - disipated_effects[i].easeOut
			disipated_effects[i].material.set_shader_param("coeficient",disipated_effects[i].last_effect - disipated_effects[i].effect * x)
		else:
			if disipated_effects[i].name == "Blur":
				blur_buffer.visible = false
				Events.emit_signal("on_pill_disipated")
			if disipated_effects[i].name == "Trip":
				trip_buffer.visible = false
				Events.emit_signal("on_tablet_disipated")
			if disipated_effects[i].name == "Whirl":
				whirl_buffer.visible = false
				Events.emit_signal("on_syringe_disipated")
				
			disipated_effects.remove(i)
	#EFFECTS
	for i in range(effects.size()-1,-1,-1):
		if effects[i].delay > 0:
			effects[i].delay -= delta
			continue
			
		if effects[i].easeIn > 0:
			effects[i].easeIn -= delta
			var x = 1 - effects[i].easeIn
			effects[i].material.set_shader_param("coeficient",effects[i].last_effect + effects[i].effect * x)
		else:
			effects[i].counter -= delta
			if effects[i].counter <= 0:
				disipate_effect(effects[i])
				effects.remove(i)
	
class Effect:
	var name
	var counter
	var effect
	var material
	var delay
	var last_effect
	
	var easeIn
	var easeOut
	func _init(_name, _effect, _time, _delay, _material):
		name = _name
		counter = _time
		effect = _effect
		material = _material
		last_effect  = material.get_shader_param("coeficient")
		delay = _delay
		easeIn = 1
		easeOut = 1

extends Control

onready var whirl_material = $Whirl/TextureRect.material
onready var black_attenuation_material = $BlackAttenuation/TextureRect2.material
onready var blur_material = $Blur/TextureRect2.material

func set_whirl_effect(value : float):
	whirl_material.set_shader_param("coeficient",value)
	
func set_black_attenuation_effect(value : float):
	black_attenuation_material.set_shader_param("coeficient",value)

func set_blur_effect(value : float):
	blur_material.set_shader_param("coeficient",value)

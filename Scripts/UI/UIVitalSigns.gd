extends Control

onready var blood_indicator = $BloodIndicator
#onready var temperature_indicator = $TemperatureIndicator
#onready var lung_indicator = $LungIndicator

func _ready():
	Events.connect("on_blood_level_update",self,"on_blood_update")
#	Events.connect("on_temperature_level_update",self,"on_temperature_update")
#	Events.connect("on_lung_level_update",self,"on_lung_update")
	
func on_blood_update(level : float):
	blood_indicator.value = level
#
#func on_temperature_update(level : float):
#	temperature_indicator.value = level
#
#func on_lung_update(level : float):
#	lung_indicator.value = level

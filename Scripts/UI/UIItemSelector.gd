extends HBoxContainer

onready var icons = [ preload("res://Textures/UIPill.png") as Texture, preload("res://Textures/UITablet.png") as Texture, preload("res://Textures/UISyringe.png") as Texture]
onready var slots = [ $Slot0, $Slot1, $Slot2 ]

var selected = -1
func _ready():
	Events.connect("on_inventory_changed",self,"on_update_inventory")
	Events.connect("on_inventory_selected_item_changed",self,"on_selection_changed")
	on_selection_changed(0)
	
func on_selection_changed(new_selected : int):
	if(selected >= 0 and selected < 3):#untint last
		slots[selected].modulate.a = 0.25
	selected = new_selected
	slots[selected].modulate.a = 1
	
func on_update_inventory(items):
	for i in range(slots.size()):
		if items[i] != null:
			slots[i].get_child(0).texture = icons[items[i]]
		else:
			slots[i].get_child(0).texture = null
	pass
	


extends HBoxContainer

onready var icons = [ preload("res://Textures/UIPill.png") as Texture, preload("res://Textures/UITablet.png") as Texture, preload("res://Textures/UISyringe.png") as Texture]
onready var slots = [ $Slot0, $Slot1, $Slot2 ]

var selected = -1
func _ready():
	GameManager.INVENTORY.connect("on_item_added",self,"on_item_added")
	GameManager.INVENTORY.connect("on_item_selection_changed",self,"on_selection_changed")
	on_selection_changed(0)
	
func on_selection_changed(new_selected : int):
	print(new_selected)
	if(selected >= 0 and selected < 3):#untint last
		slots[selected].modulate.a = 0.25
	selected = new_selected
	slots[selected].modulate.a = 1
	
func on_item_added(items):
	for i in range(items.size()):
		slots[i].get_child(0).texture = icons[items[i]]
		pass
	pass
	


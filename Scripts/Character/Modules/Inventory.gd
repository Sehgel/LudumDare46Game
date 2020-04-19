extends Node

var items : Array

signal on_item_added
signal on_item_selection_changed
var selected_index = -1

func _ready():
	GameManager.INVENTORY = self
	

func add_item(item):
	if(items.size() < 3):
		items.append(item)
	else:
		items[selected_index] = item
	emit_signal("on_item_added",items)
	

func is_empty():
	return items.size() == 0

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				change_selected((selected_index + 3 + 1) % 3)
			elif event.button_index == BUTTON_WHEEL_DOWN:
				change_selected(((selected_index + 3 - 1)) % 3)
				
func change_selected(new_index : int):
	if(new_index < 0 or new_index >= 3):
		return
	selected_index = new_index
	emit_signal("on_item_selection_changed",new_index)


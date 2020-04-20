extends Node

var items = [null, null, null]

var selected_index = 0

func add_item(item):
	
	var filled = false
	for i in range(items.size()):
		if items[i] == null:
			items[i] = item
			filled = true
			break

	if(not filled):
		items[selected_index] = item
		
	Events.emit_signal("on_inventory_changed",items)
	
func remove_item(index):
	if index >= 0:
		items[index] = null

	Events.emit_signal("on_inventory_changed",items)
func remove_selected_item():
	remove_item(selected_index)
	
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
	Events.emit_signal("on_inventory_selected_item_changed",new_index)

func get_selected_item():
	if selected_index < items.size():
		return items[selected_index]
	return null

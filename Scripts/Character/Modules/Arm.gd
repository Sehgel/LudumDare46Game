extends Spatial


onready var animation_tree = $AnimationTree
onready var state_machine = animation_tree.get("parameters/playback")


var is_moving = false
var waiting_to_get_back = false
var last_walk_state = "Idle"
var last_state = "Idle"

func switch_state(name : String):
	if name == last_state:
		return
	state_machine.travel(name)
	print("Traveled to: %s" % name)
	last_state = name
func switch_then_back(name : String):
	if name == last_state or waiting_to_get_back:
		return
		
	print("Traveled %s then back to %s " % [name,last_state])
	state_machine.start(name)
	waiting_to_get_back = true

func get_back_to_last_state():
	print("Got back to: %s" % last_state)
	state_machine.travel(last_state)
	waiting_to_get_back = false
	
func _process(delta):
	if waiting_to_get_back:
		if state_machine.get_current_node() == "Rest":
			get_back_to_last_state()
			
	var walk_state = "Walk" if is_moving else "Idle"
	if walk_state != last_walk_state:
		switch_state(walk_state)
	last_walk_state = walk_state

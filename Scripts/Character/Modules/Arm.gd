extends Spatial


onready var animation_tree = $AnimationTree
onready var state_machine = animation_tree.get("parameters/playback")

export(bool) var debugging = false

var is_moving = false
var blocked = false
var last_walk_state = "Idle"
var last_state = "Idle"

func debug(message : String):
	if debugging:
		print(message)

func switch_state(name : String):
	if name == last_state:
		return
	state_machine.travel(name)
	debug("Traveled to: %s" % name)
	last_state = name
func switch_then_back(name : String):
	if name == last_state or blocked:
		return
	debug("Traveled %s then back to %s " % [name,last_state])
	state_machine.start(name)
	blocked = true

func get_back_to_last_state():
	debug("Got back to: %s" % last_state)
	state_machine.travel(last_state)
	blocked = false
	
func _process(delta):
	if blocked:
		if state_machine.get_current_node() == "Rest":
			get_back_to_last_state()
			
	var walk_state = "Walk" if is_moving else "Idle"
	if walk_state != last_walk_state:
		switch_state(walk_state)
	last_walk_state = walk_state

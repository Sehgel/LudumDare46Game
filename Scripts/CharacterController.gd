extends KinematicBody

onready var physic_module = $Modules/Physic
onready var input_module = $Modules/Input
onready var inventory = $Modules/Inventory
onready var camera = $Camera
onready var arm = $Camera/Arm
onready var ground_raycast = $RayCast
onready var blood_particles = $Camera/Arm/Armature/Skeleton/BoneAttachment2/Particles

export(float) var walk_speed = 10
export(int, FLAGS, "Ground", "Pickup") var pickup_mask
export(bool) var debugging = false
export(float) var base_jump = 200
export(float) var jump_buff = 100

export(float) var base_particle_bleeding_velocity = 15
export(float) var particle_bleeding_velocity_buff = 5
var pickup_timer = Timer.new()
var alive = true
func _ready():
	add_child(pickup_timer)
	input_module.connect("click",self,"on_click")
	input_module.connect("T_press",self,"on_drug_take")
	input_module.connect("Space_press",self,"on_jump")
	Events.connect("on_death",self,"on_death")
	Events.connect("on_pill_taken",self,"on_jump_buff_added")
	Events.connect("on_pill_disipated",self,"on_jump_buff_disipated")
	
	Events.connect("on_tablet_taken",self,"on_bleed_buff_added")
	Events.connect("on_tablet_disipated",self,"on_bleed_buff_disipated")
	start_game()
	
func start_game():
	var timer = Timer.new()
	add_child(timer)
	timer.start(1)
	yield(timer,"timeout")
	timer.queue_free()
	print("start")
	Events.emit_signal("on_game_start")
func on_death():
	alive = false
	
func debug(message : String):
	if debugging:
		print(message)

func on_jump():
	if is_on_floor() or ground_raycast.is_colliding():
		physic_module.add_impulse(base_jump)
		arm.switch_then_back("Jump")
		

func on_click():
	if arm.blocked:
		return
	var pointed_object = get_pointed_object()
	if pointed_object:
		if(pointed_object.get_parent().is_in_group("Pickup")):
			arm.switch_then_back("Pickup")
			pickup_timer.start(1.25)
			var item = pointed_object.get_parent().pick()
			yield(pickup_timer,"timeout")
			inventory.add_item(item)
func get_pointed_object():
	var raycast = RayCast.new()
	get_tree().root.add_child(raycast)
	raycast.enabled = true
	raycast.collision_mask = pickup_mask
	raycast.collide_with_areas = true
	raycast.global_transform.origin = camera.global_transform.origin
	raycast.cast_to = -camera.global_transform.basis.z.normalized() * 20
	raycast.force_update_transform()
	raycast.force_raycast_update()
	raycast.queue_free()
	return raycast.get_collider()

func on_jump_buff_added():
	print("jump buff added")
	base_jump += jump_buff
func on_jump_buff_disipated():
	print("jump buff disipated")
	base_jump -= jump_buff
func on_bleed_buff_added():
	print("bleed buff added")
	var last = blood_particles.process_material.get("initial_velocity")
	blood_particles.process_material.set("initial_velocity",last - particle_bleeding_velocity_buff)
func on_bleed_buff_disipated():
	print("bleed buff disipated")
	var last = blood_particles.process_material.get("initial_velocity")
	blood_particles.process_material.set("initial_velocity",last + particle_bleeding_velocity_buff)
	
func on_drug_take():
	if inventory.is_empty() or arm.blocked:
		return
		
	var item = inventory.get_selected_item()
	if item == null:
		return
		
	debug("Taking drug " + str(item))
	if item == 0:
		arm.switch_then_back("TakeDrug")
		Events.emit_signal("on_pill_taken")
	elif item == 1:
		arm.switch_then_back("TakeDrug")
		Events.emit_signal("on_tablet_taken")
	else:
		arm.switch_then_back("Syringe")
		Events.emit_signal("on_syringe_applied")
	inventory.remove_selected_item()

func _physics_process(delta):
	if not alive:
		return
		
	rotation.y = camera.camera_rotation.y
	physic_module.set_grounded(is_on_floor())
	arm.is_moving = input_module.pressing_any_button()
	var move_vector = (global_transform.basis.x * input_module.horizontal + global_transform.basis.z *-input_module.vertical)
	physic_module.move(move_vector,walk_speed)
	physic_module.velocity = move_and_slide(physic_module.velocity,Vector3.UP,true,4,0.78,false)

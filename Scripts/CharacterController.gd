extends KinematicBody

onready var physic_module = $Modules/Physic
onready var input_module = $Modules/Input
onready var inventory = $Modules/Inventory
onready var camera = $Camera
onready var arm = $Camera/Arm

export(float) var walk_speed = 10
export(int, FLAGS, "Ground", "Pickup") var pickup_mask
export(bool) var debugging = false
func _ready():
	input_module.connect("click",self,"on_click")
	input_module.connect("T_press",self,"on_drug_take")
	
	
	
func debug(message : String):
	if debugging:
		print(message)
func on_click():
	if arm.blocked:
		return
	var pointed_object = get_pointed_object()
	if pointed_object:
		if(pointed_object.get_parent().is_in_group("Pickup")):
			arm.switch_then_back("Pickup")
			var item = pointed_object.get_parent().pick()
			inventory.add_item(item)
func get_pointed_object():
	var raycast = RayCast.new()
	get_tree().root.add_child(raycast)
	raycast.enabled = true
	raycast.collision_mask = pickup_mask
	raycast.collide_with_areas = true
	raycast.global_transform.origin = camera.global_transform.origin
	raycast.cast_to = -camera.global_transform.basis.z.normalized() * 500
	raycast.force_update_transform()
	raycast.force_raycast_update()
	raycast.queue_free()
	return raycast.get_collider()
	
func on_drug_take():
	if inventory.is_empty() or arm.blocked:
		return
		
	debug("Taking drug")
	arm.switch_then_back("TakeDrug")

func _physics_process(delta):
	rotation.y = camera.camera_rotation.y
	physic_module.set_grounded(is_on_floor())
	arm.is_moving = input_module.pressing_any_button()
	var move_vector = (global_transform.basis.x * input_module.horizontal + global_transform.basis.z *-input_module.vertical)
	physic_module.move(move_vector,walk_speed)
	move_and_slide(physic_module.velocity,Vector3.UP,true,4,0.78)

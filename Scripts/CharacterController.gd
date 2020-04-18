extends KinematicBody

onready var physic_module = $Modules/Physic
onready var input_module = $Modules/Input
onready var camera = $Camera
onready var arm = $Camera/Arm

export(float) var walk_speed = 10

func _ready():
	input_module.connect("click",self,"on_click")
	input_module.connect("T_press",self,"on_drug_take")
	
	
	
func on_click():
	arm.switch_then_back("Pickup")
	
func on_drug_take():
	arm.switch_then_back("TakeDrug")

func _physics_process(delta):
	rotation.y = camera.camera_rotation.y
	physic_module.set_grounded(is_on_floor())
	arm.is_moving = input_module.pressing_any_button()
	var move_vector = (global_transform.basis.x * input_module.horizontal + global_transform.basis.z *-input_module.vertical)
	physic_module.move(move_vector,walk_speed)
	move_and_slide(physic_module.velocity,Vector3.UP,true,4,0.78)

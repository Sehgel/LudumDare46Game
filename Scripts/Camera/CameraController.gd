extends Spatial

export(float) var mouse_speed = 10

onready var input = $Input
var camera_rotation = Vector3.ZERO
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _process(delta):
	camera_rotation.y += -input.mouse_axis.x * delta * mouse_speed
	camera_rotation.x += -input.mouse_axis.y * delta * mouse_speed

	camera_rotation.x = clamp(camera_rotation.x,-PI/2,PI/2)

	rotation = Vector3(camera_rotation.x,0,0)

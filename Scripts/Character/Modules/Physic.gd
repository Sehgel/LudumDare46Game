extends Node

const GRAVITY = 9.8

var velocity : Vector3
var grounded = false

func set_grounded(value):
	grounded = value

func move(direction : Vector3, speed):
	velocity.x = direction.x * speed;
	velocity.z = direction.z * speed;

func add_impulse(force : float):
	velocity.y = force

func _physics_process(delta):
	if(not grounded):
		velocity.y -= GRAVITY

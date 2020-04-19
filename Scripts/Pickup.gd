extends RigidBody

enum ITEM_TYPE{
	CAPSULE,
	TABLET,
	SYRINGE
}

export(ITEM_TYPE) var type = ITEM_TYPE.CAPSULE

func pick():
	queue_free()
	return type

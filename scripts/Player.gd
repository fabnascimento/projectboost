extends RigidBody3D

@export_range(750, 2000) var thrust: float = 1000
@export_range(50, 750) var torque_force: float = 100
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
	
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_force * delta))

	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_force * delta))


func _on_body_entered(body: Node) -> void:
	if "goal" in body.get_groups():
		complete_level()
	
	if "obstacle" in body.get_groups():
		crash_sequence()

func crash_sequence() -> void:
	print('eita')
	get_tree().reload_current_scene()

func complete_level() -> void:
	print("completou")
	get_tree().quit()

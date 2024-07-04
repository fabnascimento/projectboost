extends RigidBody3D

@export_range(750, 2000) var thrust: float = 1000
@export_range(50, 750) var torque_force: float = 100

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var thrust_audio: AudioStreamPlayer3D = $ThrustAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var left_booster: GPUParticles3D = $LeftBooster
@onready var right_booster: GPUParticles3D = $RightBooster

var is_transitioning: bool = false
var is_accelerating: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		if not thrust_audio.playing:
			thrust_audio.play()
			booster_particles.emitting = true
	else:
		thrust_audio.stop()
		booster_particles.emitting = false
	
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_force * delta))
		right_booster.emitting = true
	else:
		right_booster.emitting = false

	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_force * delta))
		left_booster.emitting = true
	else:
		left_booster.emitting = false


func _on_body_entered(body: Node) -> void:
	if not is_transitioning:
		if "goal" in body.get_groups():
			complete_level(body.file_path)
		
		if "obstacle" in body.get_groups():
			crash_sequence()

func crash_sequence() -> void:
	explosion_audio.play()
	set_transition_state(true)
	set_process(false)
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(get_tree().reload_current_scene)
	

func complete_level(next_level_file: String) -> void:
	set_transition_state(true)
	set_process(false)
	success_audio.play()
	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(set_transition_state.bind(false))
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))

func set_transition_state(value: bool) -> void:
	is_transitioning = value

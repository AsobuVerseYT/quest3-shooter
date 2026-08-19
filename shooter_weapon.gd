extends Node3D
## Fires projectiles from a hand-held gun when the index trigger on the
## matching XRController3D is pulled. Attach this script to the gun's
## Node3D, and set the "controller" export to the XRController3D node
## it is parented to (right or left hand).

enum Hand { LEFT, RIGHT }

@export var hand: Hand = Hand.RIGHT
@export var muzzle: Node3D
@export var projectile_scene: PackedScene
@export var projectile_speed: float = 25.0
@export var fire_cooldown: float = 0.15
@export var haptic_amplitude: float = 0.5
@export var haptic_duration_ms: int = 50

var _cooldown_timer: float = 0.0
var _controller: XRController3D

func _ready() -> void:
	# Walk up to find the XRController3D this weapon is parented under.
	var p := get_parent()
	while p and not (p is XRController3D):
		p = p.get_parent()
	_controller = p as XRController3D

func _process(delta: float) -> void:
	if _cooldown_timer > 0.0:
		_cooldown_timer -= delta

	if _controller == null:
		return

	var trigger_value: float = _controller.get_float("trigger")
	if trigger_value > 0.6 and _cooldown_timer <= 0.0:
		_fire()
		_cooldown_timer = fire_cooldown

func _fire() -> void:
	if projectile_scene == null or muzzle == null:
		push_warning("ShooterWeapon: assign projectile_scene and muzzle in the Inspector.")
		return

	var bullet := projectile_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_transform = muzzle.global_transform

	if bullet is RigidBody3D:
		bullet.linear_velocity = -muzzle.global_transform.basis.z * projectile_speed

	if _controller:
		_controller.trigger_haptic_pulse("haptic", 0.0, haptic_amplitude, haptic_duration_ms, 0.0)

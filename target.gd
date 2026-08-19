extends AnimatableBody3D
## A shootable target. This script goes on the AnimatableBody3D root of
## target.tscn (already in the "target" group via the scene file) so
## Projectile.gd's body_entered signal can find it and call take_damage().
## AnimatableBody3D (not StaticBody3D) is used because it moves every frame
## and should still correctly push/collide with the bullet RigidBody3D.

@export var health: int = 1
@export var point_value: int = 10
@export var moves: bool = true
@export var move_speed: float = 1.5
@export var move_axis: Vector3 = Vector3.RIGHT
@export var patrol_distance: float = 1.5
@export var destroy_vfx_scene: PackedScene

var _start_pos: Vector3
var _t: float = 0.0
var _direction: int = 1

func _ready() -> void:
	add_to_group("target")
	_start_pos = position

func _process(delta: float) -> void:
	if not moves:
		return

	_t += delta * move_speed * _direction
	if _t > patrol_distance or _t < 0.0:
		_direction *= -1

	position = _start_pos + move_axis.normalized() * _t

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		_die()

func _die() -> void:
	if GameManager:
		GameManager.add_score(point_value)

	if destroy_vfx_scene:
		var vfx := destroy_vfx_scene.instantiate()
		get_tree().current_scene.add_child(vfx)
		vfx.global_position = global_position

	queue_free()

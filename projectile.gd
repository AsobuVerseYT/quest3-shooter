extends RigidBody3D
## Simple bullet: flies forward under its own velocity, damages anything in
## the "target" group it touches, and cleans itself up after a short
## lifespan. Attach to a small RigidBody3D (sphere collider), gravity off,
## Continuous CD enabled (Inspector > RigidBody3D > CCD) so fast bullets
## don't tunnel through thin target meshes.

@export var damage: int = 1
@export var lifespan: float = 3.0
@export var hit_vfx_scene: PackedScene

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(lifespan).timeout.connect(func(): if is_instance_valid(self): queue_free())

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("target") and body.has_method("take_damage"):
		body.take_damage(damage)

	if hit_vfx_scene:
		var vfx := hit_vfx_scene.instantiate()
		get_tree().current_scene.add_child(vfx)
		vfx.global_position = global_position

	if not body.is_in_group("player"):
		queue_free()

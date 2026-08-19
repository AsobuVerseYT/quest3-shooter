extends Node3D
## Spawns Target scenes at a set of spawn points (Marker3D children of
## "SpawnPoints") on a timer, keeping a capped number of live targets.

@export var target_scene: PackedScene
@export var spawn_interval: float = 1.5
@export var max_concurrent_targets: int = 5
@export var difficulty_ramp_per_wave: float = 0.92 # <1 = gets harder
@export var wave_length: float = 15.0

@onready var spawn_points: Array[Node3D] = []

var _live: Array[Node] = []
var _current_interval: float
var _wave_timer: float = 0.0
var _spawn_timer: float = 0.0

func _ready() -> void:
	var points_parent := get_node_or_null("SpawnPoints")
	if points_parent:
		for child in points_parent.get_children():
			if child is Node3D:
				spawn_points.append(child)

	_current_interval = spawn_interval

func _process(delta: float) -> void:
	_live = _live.filter(func(t): return is_instance_valid(t))

	_wave_timer += delta
	if _wave_timer >= wave_length:
		_wave_timer = 0.0
		_current_interval = max(0.3, _current_interval * difficulty_ramp_per_wave)

	_spawn_timer += delta
	if _spawn_timer >= _current_interval:
		_spawn_timer = 0.0
		_try_spawn()

func _try_spawn() -> void:
	if GameManager and not GameManager.is_playing:
		return
	if _live.size() >= max_concurrent_targets or spawn_points.is_empty() or target_scene == null:
		return

	var point: Node3D = spawn_points[randi() % spawn_points.size()]
	var t := target_scene.instantiate()
	get_tree().current_scene.add_child(t)
	t.global_transform = point.global_transform
	_live.append(t)

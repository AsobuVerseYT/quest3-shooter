extends Node
## Central game state: score, countdown timer, win/lose flow.
## Attach to a Node called "GameManager" in the main scene, and set it as
## an Autoload (Project Settings > Autoload) named "GameManager" so any
## script can reach it via GameManager.add_score(10).

signal score_changed(new_score: int)
signal time_changed(seconds_left: int)
signal match_ended(final_score: int)

@export var match_duration: float = 60.0

var is_playing: bool = true
var _score: int = 0
var _time_remaining: float = 0.0

func _ready() -> void:
	_time_remaining = match_duration
	_score = 0
	is_playing = true
	score_changed.emit(_score)
	time_changed.emit(int(ceil(_time_remaining)))

func _process(delta: float) -> void:
	if not is_playing:
		return

	_time_remaining -= delta
	if _time_remaining <= 0.0:
		_time_remaining = 0.0
		_end_match()

	time_changed.emit(int(ceil(_time_remaining)))

func add_score(points: int) -> void:
	if not is_playing:
		return
	_score += points
	score_changed.emit(_score)

func _end_match() -> void:
	is_playing = false
	match_ended.emit(_score)

func restart_game() -> void:
	get_tree().reload_current_scene()

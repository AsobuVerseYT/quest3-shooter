extends Node3D
## Drives a world-space UI: a Label3D or SubViewport-based Control showing
## score/time, plus a "Game Over" panel shown when the match ends. Wire up
## the @onready paths below to match your scene's node names, or simplify
## to plain Label3D nodes if you skip the Control/SubViewport approach.

@onready var score_label: Label3D = $ScoreLabel3D
@onready var timer_label: Label3D = $TimerLabel3D
@onready var game_over_label: Label3D = $GameOverLabel3D

func _ready() -> void:
	game_over_label.visible = false
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.time_changed.connect(_on_time_changed)
	GameManager.match_ended.connect(_on_match_ended)

func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score

func _on_time_changed(seconds_left: int) -> void:
	timer_label.text = "Time: %ds" % seconds_left

func _on_match_ended(final_score: int) -> void:
	game_over_label.text = "GAME OVER\nFinal score: %d" % final_score
	game_over_label.visible = true

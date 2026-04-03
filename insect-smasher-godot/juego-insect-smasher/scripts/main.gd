extends Node2D

@onready var score_label: Label = $ScoreLabel
@onready var spawn_timer: Timer = $SpawnTimer

var score: int = 0

const INSECTS := [
	{"type": "Araña", "speed": 60, "points": 1},
	{"type": "Mariquita", "speed": 100, "points": 5},
	{"type": "Mosca", "speed": 120, "points": 7},
	{"type": "Murcielago", "speed": 180, "points": 10},
	{"type": "Abeja", "speed": 150, "points": 0}
]

func _ready() -> void:
	update_score()
	spawn_timer.timeout.connect(_on_SpawnTimer_timeout)

func _on_SpawnTimer_timeout() -> void:
	spawn_insect()

func spawn_insect() -> void:
	var insect_scene := preload("res://scenes/Insect.tscn")
	var insect := insect_scene.instantiate()


	insect.position = Vector2(
		randi_range(100, 1100),
		randi_range(100, 600)
	)

	add_child(insect)
	insect.killed.connect(on_insect_killed)

func on_insect_killed(points: int, is_bee: bool) -> void:
	if is_bee:
		game_over()
	else:
		score += points
		update_score()

func update_score() -> void:
	score_label.text = "Puntuación: %d" % score

func game_over() -> void:
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

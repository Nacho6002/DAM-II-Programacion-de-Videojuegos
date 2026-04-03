extends Area2D

signal killed(points, is_bee)

var speed: int
var points: int
var is_bee: bool
var direction: Vector2

func setup(data: Dictionary) -> void:
	points = data["points"]
	speed = data["speed"]
	is_bee = data["type"] == "abeja"
	
	$Sprite2D.texture = load("res://sprites/%s.png" % data["type"])
	
	direction = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

func _process(delta: float) -> void:
	position += direction * speed * delta

func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed:
		emit_signal("killed", points, is_bee)
		queue_free()

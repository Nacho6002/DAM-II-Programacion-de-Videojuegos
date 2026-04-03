extends CharacterBody2D

# CONFIGURACIÓN
@export var puntos_que_doy = 2 
@export var velocidad = 400.0


@onready var sonido_muerte = $AudioStreamPlayer2D 

var esta_muerto = false

func _ready():
	# 1. MOVIMIENTO
	var centro_pantalla = get_viewport_rect().size / 2
	var variacion = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	var direccion = ((centro_pantalla + variacion) - position).normalized()
	velocity = direccion * velocidad
	
	# 2. ANIMACIÓN
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("volar")
		
	# 3. COLISIONES Y GRUPO
	collision_mask = 0 
	input_pickable = true
	add_to_group("bichos") 

func _physics_process(delta):
	if esta_muerto: return

	move_and_slide()
	
	# Limpieza si se van muy lejos
	if position.distance_to(Vector2(576, 324)) > 1500:
		queue_free()

	# Rebote en bordes
	if get_slide_collision_count() > 0:
		var colision = get_slide_collision(0)
		velocity = velocity.bounce(colision.get_normal())

	# Voltear Sprite
	if has_node("AnimatedSprite2D"):
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false

# --- CLIC DEL JUGADOR ---
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		matar_bicho()

func matar_bicho():
	if esta_muerto: return 
	esta_muerto = true 
	
	# Desactivar colisión para que no le des dos veces
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	
	# Animación de morir
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("morir")

	# --- ¡NUEVO! REPRODUCIR SONIDO ASQUEROSO ---
	if sonido_muerte:
		sonido_muerte.play()
	
	

	# SUMAR PUNTOS
	Global.sumar_puntos(puntos_que_doy)
	

	if sonido_muerte:
		await sonido_muerte.finished
	else:
		# Si no hay sonido, usamos el temporizador antiguo por seguridad
		await get_tree().create_timer(0.5).timeout
		
	queue_free()

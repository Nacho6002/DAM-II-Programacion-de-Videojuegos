extends CharacterBody2D


@export var velocidad = 300.0 

# --- ¡NUEVO! SONIDO ---
@onready var sonido_muerte = $AudioStreamPlayer2D 

var esta_muerto = false

func _ready():
	var centro_pantalla = get_viewport_rect().size / 2
	var variacion = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	var direccion = ((centro_pantalla + variacion) - position).normalized()
	velocity = direccion * velocidad
	
	# 2. ANIMACIÓN
	if $AnimatedSprite2D.sprite_frames.has_animation("volar"):
		$AnimatedSprite2D.play("volar")
	else:
		$AnimatedSprite2D.play("default") 
		
	# 3. COLISIONES Y GRUPO
	collision_mask = 0 
	input_pickable = true
	add_to_group("bichos") 

func _physics_process(delta):
	if esta_muerto: return
	move_and_slide()
	
	# AUTODESTRUCCIÓN SI SE ALEJA
	if position.distance_to(Vector2(576, 324)) > 1500:
		queue_free()

	# Rebote
	if get_slide_collision_count() > 0:
		var colision = get_slide_collision(0)
		velocity = velocity.bounce(colision.get_normal())
	
	# Voltear
	if velocity.x > 0: $AnimatedSprite2D.flip_h = true
	else: $AnimatedSprite2D.flip_h = false

# --- CLIC DEL JUGADOR ---
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		matar_bicho()

func matar_bicho():
	if esta_muerto: return 
	esta_muerto = true 
	
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Animación de muerte
	if $AnimatedSprite2D.sprite_frames.has_animation("morir"):
		$AnimatedSprite2D.play("morir")

	if sonido_muerte:
		sonido_muerte.play()
	
	Global.registrar_golpe_gusano()
	
	
	if !is_inside_tree(): 
		return 
	
	
	if sonido_muerte:
		await sonido_muerte.finished
	else:
		await get_tree().create_timer(0.5).timeout
		
	queue_free()

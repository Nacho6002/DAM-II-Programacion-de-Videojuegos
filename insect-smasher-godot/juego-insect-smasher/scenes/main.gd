extends Node2D

# --- ESCENAS DE BICHOS ---
@export var abeja_scene : PackedScene      
@export var arana_scene : PackedScene      
@export var mariquita_scene : PackedScene  
@export var mosca_scene : PackedScene      
@export var murcielago_scene : PackedScene
@export var gusano_trampa_scene : PackedScene

# --- CARGA DE FONDOS ---
var img_nivel1 = preload("res://Assets/Background/Fondo Ronda 1.png")
var img_nivel2 = preload("res://Assets/Background/FondoNivel2.png")
var img_nivel3 = preload("res://Assets/Background/FondoNivel3.png")
var img_nivel4 = preload("res://Assets/Background/FondoNivel4.png")
var img_nivel5 = preload("res://Assets/Background/FondoNivel5.png")
var img_nivel6 = preload("res://Assets/Background/FondoNivel6.png") 

# --- REFERENCIAS A NODOS ---
@onready var background = $Background
@onready var cortinilla = $Cortinilla
@onready var viento_hojas = $VientoHojas 
@onready var luciernagas = $Luciernagas 
@onready var lluvia = $Lluvia
@onready var tormenta_arena = $TormentaArena 
@onready var nieve = $Nieve 
@onready var brasas = $Brasas 

# --- SONIDOS ---
@onready var musica_fondo = $MusicaFondo   
@onready var sonido_golpe = $SonidoGolpe   

# CONFIGURACIÓN
var max_bichos_en_pantalla = 20
var cambiando_escenario = false 

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	# Configuración inicial de visibilidad
	cortinilla.modulate.a = 0.0
	cortinilla.visible = true 
	
	# --- APAGAR TODOS LOS EFECTOS AL INICIO ---
	if luciernagas: luciernagas.emitting = false; luciernagas.visible = false
	if lluvia: lluvia.emitting = false; lluvia.visible = false
	if tormenta_arena: tormenta_arena.emitting = false; tormenta_arena.visible = false
	if nieve: nieve.emitting = false; nieve.visible = false
	if brasas: brasas.emitting = false; brasas.visible = false 
	
	# ENCENDER MÚSICA
	if musica_fondo and !musica_fondo.playing:
		musica_fondo.play()
	
	Global.LabelPuntos = $HUD/LabelPuntos
	Global.LabelTiempo = $HUD/LabelTiempo
	Global.LabelMeta = $HUD/LabelOleada 
	
	Global.reset_game()
	
	# EMPUJÓN INICIAL DE BICHOS
	for i in range(15):
		spawn_balanceado()
	
	$InsectSpawn.start()

func _process(delta):
	if !is_inside_tree(): return

	
	if Input.is_key_pressed(KEY_3): Global.Nivel = 3
	if Input.is_key_pressed(KEY_4): Global.Nivel = 4
	if Input.is_key_pressed(KEY_5): Global.Nivel = 5
	if Input.is_key_pressed(KEY_6): Global.Nivel = 6 

	if musica_fondo:
		var velocidad_deseada = 1.0 + (Global.Nivel * 0.05)
		musica_fondo.pitch_scale = lerp(musica_fondo.pitch_scale, velocidad_deseada, delta * 0.5)

	# GAME OVER
	if Global.TiempoRestante <= 0:
		game_over()
		return

	# RELOJ Y ETIQUETAS
	Global.TiempoRestante -= delta
	Global.refreshLabels()

	# CAMBIO DE NIVEL 
	
	# Paso a Nivel 2
	if Global.Nivel == 2 and background.texture != img_nivel2 and not cambiando_escenario:
		cambiar_de_fondo(img_nivel2)
		
	# Paso a Nivel 3
	elif Global.Nivel == 3 and background.texture != img_nivel3 and not cambiando_escenario:
		cambiar_de_fondo(img_nivel3)

	# Paso a Nivel 4 (Desierto)
	elif Global.Nivel == 4 and background.texture != img_nivel4 and not cambiando_escenario:
		cambiar_de_fondo(img_nivel4)

	# Paso a Nivel 5 (Nieve)
	elif Global.Nivel == 5 and background.texture != img_nivel5 and not cambiando_escenario:
		cambiar_de_fondo(img_nivel5)

	# Paso a Nivel 6 (Volcán)
	elif Global.Nivel == 6 and background.texture != img_nivel6 and not cambiando_escenario:
		cambiar_de_fondo(img_nivel6)

	
	if get_tree().get_nodes_in_group("bichos").size() < 10:
		spawn_balanceado()
		
	# Dificultad progresiva
	var tiempo_base = 0.8
	var tiempo_nuevo = tiempo_base / Global.MultiplicadorVelocidad
	if tiempo_nuevo < 0.1: tiempo_nuevo = 0.1
	$InsectSpawn.wait_time = tiempo_nuevo

	# MATAMOSCAS Y SONIDO DE GOLPE
	if has_node("Matamoscas"):
		$Matamoscas.global_position = get_global_mouse_position()
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			$Matamoscas.rotation_degrees = 50
			$Matamoscas.scale = Vector2(0.3, 0.3)
			
			if sonido_golpe and !sonido_golpe.playing:
				sonido_golpe.play()
				
		else:
			$Matamoscas.rotation_degrees = 20
			$Matamoscas.scale = Vector2(0.4, 0.4)


func cambiar_de_fondo(nueva_textura):
	cambiando_escenario = true
	var tween = create_tween()
	
	# 1. Oscurecer la pantalla
	tween.tween_property(cortinilla, "modulate:a", 1.0, 1.0)
	
	# 2. CAMBIO DE LOOK
	tween.tween_callback(func():
		background.texture = nueva_textura
		
		# GESTIÓN DE EFECTOS 
		
		# 1. APAGAR TODO (Reset)
		if viento_hojas: viento_hojas.visible = false; viento_hojas.emitting = false
		if luciernagas: luciernagas.visible = false; luciernagas.emitting = false
		if lluvia: lluvia.visible = false; lluvia.emitting = false
		if tormenta_arena: tormenta_arena.visible = false; tormenta_arena.emitting = false
		if nieve: nieve.visible = false; nieve.emitting = false
		if brasas: brasas.visible = false; brasas.emitting = false 
		
		background.modulate = Color(1, 1, 1) # Reset color

		# 2. ENCENDER SOLO LO QUE TOCA
		
		if Global.Nivel == 2: # Pantano
			if luciernagas: luciernagas.visible = true; luciernagas.emitting = true
			background.modulate = Color(0.4, 0.4, 0.5)
			
		elif Global.Nivel == 3: # Lluvia
			if lluvia: lluvia.visible = true; lluvia.emitting = true

		elif Global.Nivel == 4: # Desierto
			if tormenta_arena: tormenta_arena.visible = true; tormenta_arena.emitting = true
		
		elif Global.Nivel == 5: # Nieve
			if nieve: nieve.visible = true; nieve.emitting = true
			background.modulate = Color(0.8, 0.9, 1.0)

		# NIVEL 6 (VOLCÁN)
		elif Global.Nivel == 6:
			if brasas: brasas.visible = true; brasas.emitting = true
			background.modulate = Color(1, 0.8, 0.8) 
	)
	
	# 3. Esperar
	tween.tween_interval(0.5)
	
	# 4. Aclarar
	tween.tween_property(cortinilla, "modulate:a", 0.0, 1.0)
	
	# 5. Desbloquear
	tween.tween_callback(func():
		cambiando_escenario = false
	)

func _on_insect_spawn_timeout() -> void:
	if !is_inside_tree(): return
	if get_tree().get_nodes_in_group("bichos").size() < max_bichos_en_pantalla:
		spawn_balanceado()

# --- SPAWN DE BICHOS ---
func spawn_balanceado():
	var enemigo_final = null
	var dado = randf() 
	
	if dado < 0.30: enemigo_final = abeja_scene       
	elif dado < 0.50: enemigo_final = arana_scene       
	elif dado < 0.70: enemigo_final = mariquita_scene  
	elif dado < 0.85: enemigo_final = mosca_scene       
	elif dado < 0.90: enemigo_final = murcielago_scene
	else: enemigo_final = gusano_trampa_scene          
	
	if enemigo_final == null: 
		if abeja_scene: enemigo_final = abeja_scene
		else: return 

	var bicho = enemigo_final.instantiate()
	
	var lado = randi() % 4
	var pos_final = Vector2.ZERO
	
	match lado:
		0: pos_final = Vector2(randf_range(0, 1152), -100) 
		1: pos_final = Vector2(randf_range(0, 1152), 700)  
		2: pos_final = Vector2(-100, randf_range(0, 648))  
		3: pos_final = Vector2(1250, randf_range(0, 648))  
	
	bicho.position = pos_final
	
	if "velocidad" in bicho:
		bicho.velocidad = bicho.velocidad * Global.MultiplicadorVelocidad
	
	add_child(bicho)

func game_over():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

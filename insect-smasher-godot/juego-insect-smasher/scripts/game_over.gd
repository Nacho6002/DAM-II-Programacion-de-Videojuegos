extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	
	if MusicaGlobal.playing:
		MusicaGlobal.stop()
	
	
	if has_node("MusicaDerrota"):
		$MusicaDerrota.play()
	
	# Mostrar PUNTOS
	if has_node("PanelRecord/VBoxContainer/LabelTitulo"):
		$PanelRecord/VBoxContainer/LabelTitulo.text = "Puntos: " + str(Global.Puntos)
	
	# Mostrar RÉCORD
	if has_node("PanelRecord/VBoxContainer/LabelRecord"):
		$PanelRecord/VBoxContainer/LabelRecord.text = "Récord: " + str(Global.Record)
	var label_nuevo = get_node_or_null("PanelRecord/VBoxContainer/LabelNuevo")
	if label_nuevo != null:
		if Global.Puntos >= Global.Record and Global.Puntos > 0:
			label_nuevo.visible = true
			label_nuevo.modulate = Color(1, 1, 0)
		else:
			label_nuevo.visible = false

	# --- 2. CONEXIÓN DE BOTONES ---
	
	var boton_reintentar = get_node_or_null("PanelRecord/BotonReintentar")
	if boton_reintentar: 
		if !boton_reintentar.pressed.is_connected(_on_Reintentar_pressed):
			boton_reintentar.pressed.connect(_on_Reintentar_pressed)
			if !boton_reintentar.mouse_entered.is_connected(_on_boton_reintentar_mouse_entered):
				boton_reintentar.mouse_entered.connect(_on_boton_reintentar_mouse_entered)
	
	var boton_salir = get_node_or_null("PanelRecord/BotonSalir")
	if boton_salir: 
		if !boton_salir.pressed.is_connected(_on_Salir_pressed):
			boton_salir.pressed.connect(_on_Salir_pressed)
			# Conectamos también el sonido hover
			if !boton_salir.mouse_entered.is_connected(_on_boton_salir_mouse_entered):
				boton_salir.mouse_entered.connect(_on_boton_salir_mouse_entered)

func _on_Reintentar_pressed() -> void:
	if has_node("SonidoClick"):
		$SonidoClick.play()
	
	
	MusicaGlobal.stop()
	
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_Salir_pressed() -> void:
	if has_node("SonidoClick"):
		$SonidoClick.play()
	get_tree().quit()

func _on_boton_salir_mouse_entered() -> void:
	if has_node("SonidoHover"):
		$SonidoHover.play()

func _on_boton_reintentar_mouse_entered() -> void:
	if has_node("SonidoHover"):
		$SonidoHover.play()

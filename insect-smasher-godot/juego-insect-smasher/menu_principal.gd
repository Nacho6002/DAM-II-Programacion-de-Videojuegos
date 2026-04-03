extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	
	if not MusicaGlobal.playing:
		MusicaGlobal.play()
	
	# MOSTRAR EL RÉCORD
	if has_node("LabelRecord"):
		$LabelRecord.text = "Mejor Récord: " + str(Global.Record)

# --- BOTÓN JUGAR ---
func _on_boton_jugar_pressed() -> void:
	if has_node("SonidoClick"): 
		$SonidoClick.play()
	

	MusicaGlobal.stop()
	
	Global.reset_game()

	get_tree().change_scene_to_file("res://scenes/Main.tscn")

# --- BOTÓN SALIR ---
func _on_boton_salir_pressed() -> void:
	if has_node("SonidoClick"): 
		$SonidoClick.play()
	get_tree().quit()

# --- BOTÓN REGLAS ---
func _on_boton_reglas_pressed() -> void:
	if has_node("SonidoClick"): 
		$SonidoClick.play()
	

	get_tree().change_scene_to_file("res://pantalla_reglas.tscn")

# SONIDOS AL PASAR EL RATÓN 
func _on_boton_jugar_mouse_entered() -> void:
	if has_node("SonidoHover"): $SonidoHover.play()

func _on_boton_salir_mouse_entered() -> void:
	if has_node("SonidoHover"): $SonidoHover.play()

func _on_boton_reglas_mouse_entered() -> void:
	if has_node("SonidoHover"): $SonidoHover.play()

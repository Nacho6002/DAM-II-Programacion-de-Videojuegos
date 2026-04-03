extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# --- BOTÓN VOLVER ---
func _on_boton_volver_pressed() -> void:
	if has_node("SonidoClick"):
		$SonidoClick.play()
	

	get_tree().change_scene_to_file("res://menu_principal.tscn") 


func _on_boton_volver_mouse_entered() -> void:
	if has_node("SonidoHover"):
		$SonidoHover.play()

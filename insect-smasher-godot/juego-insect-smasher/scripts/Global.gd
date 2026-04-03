extends Node

# --- VARIABLES DEL JUEGO ---
var Puntos = 0
var Record = 0
var TiempoRestante = 25.0
var Meta = 20
var Nivel = 1

# --- SISTEMA DE TRAMPAS (GUSANO) ---
var GusanosGolpeados = 0  # Cuenta los errores
var MaxErroresGusano = 3  # Al tercer error, pierdes

var MultiplicadorVelocidad = 1.0 

# ETIQUETAS
var LabelPuntos
var LabelTiempo
var LabelMeta

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func reset_game():
	Puntos = 0
	Meta = 20
	Nivel = 1
	TiempoRestante = 25.0
	MultiplicadorVelocidad = 1.0
	GusanosGolpeados = 0  
	refreshLabels()

func sumar_puntos(cantidad):
	Puntos += cantidad
	if Puntos >= Meta:
		subir_nivel()
	if Puntos > Record:
		Record = Puntos
	refreshLabels()


func registrar_golpe_gusano():
	GusanosGolpeados += 1
	print("¡ERROR! Gusanos golpeados: " + str(GusanosGolpeados))
	
	
	if GusanosGolpeados >= MaxErroresGusano:
		
		get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

func subir_nivel():
	Nivel += 1
	Meta += (20 + (Nivel * 10))
	TiempoRestante += 15.0
	MultiplicadorVelocidad += 0.15
	print("¡NIVEL " + str(Nivel) + "! Velocidad x" + str(MultiplicadorVelocidad))

func refreshLabels():
	if LabelPuntos != null:
		LabelPuntos.text = "Puntos: " + str(Puntos)
	
	if LabelTiempo != null:
		LabelTiempo.text = "Tiempo: " + str(int(TiempoRestante)) + "s"
		if TiempoRestante < 10:
			LabelTiempo.modulate = Color(1, 0, 0)
		else:
			LabelTiempo.modulate = Color(1, 1, 1)
		
	if LabelMeta != null:
		LabelMeta.text = "Meta Nvl " + str(Nivel) + ": " + str(Meta)

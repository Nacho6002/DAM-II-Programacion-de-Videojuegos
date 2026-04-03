extends Label

var tiempo_acumulado = 0.0

func _process(delta):
	
	tiempo_acumulado += delta
	
	
	var segundos = int(tiempo_acumulado)
	
	
	text = "Tiempo: " + str(segundos)

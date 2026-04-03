extends Label

func _ready():
	Global.LabelMissed = self
	Global.refreshLabels()

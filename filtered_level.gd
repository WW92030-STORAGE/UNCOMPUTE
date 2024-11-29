class_name FilteredLevel
extends Level

func _ready() -> void:
	super._ready()
	
	print("FILTERED LEVEL")
	
	if GlobalVariables.FILTER != Color(0, 0, 0, 0):
		$CanvasModulate.color = GlobalVariables.FILTER

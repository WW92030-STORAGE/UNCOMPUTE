class_name PlayerEnd
extends Node2D

var colorIndex = 0
var red
var green
var blue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	colorIndex += 1
	colorIndex = colorIndex % (6 * 256)
	
	var index = int(colorIndex / 256)
	var val = (colorIndex / 256.0) - index
	
	if (index == 0):
		red = 1
		blue = 0
		green = val
	elif (index == 1):
		red = 1 - val
		green = 1
		blue = 0
	elif (index == 2):
		red = 0
		green = 1
		blue = val
	elif (index == 3):
		red = 0
		green = 1 - val
		blue = 1
	elif (index == 4):
		red = val
		green = 0
		blue = 1
	elif (index == 5):
		red = 1
		green = 0
		blue = 1 - val
	else:
		red = 1
		green = 1
		blue = 1
	
	
	$END_AREA/Sprite2D.set_modulate(Color(red, green, blue, 0.25))
	

extends Node

# Audio volume for pulsing objects

var VOLUME = 0
var VOLZEROTIMER = 0

# Dimensions and constants 

var TL = Vector2(-10000, -10000)
var BR = Vector2(10000, 10000)

var PASS_THRESH = 30

var START_TIME = 0

# Color values

var RED = Color(1, 0, 0, 1)
var STRONG = Color(0, 0, 0, 1);
var GREEN = Color(0, 1, 0, 1)
var BLUE = Color(0, 0, 1, 1)

var FILTER = Color(0, 0, 0, 0)
var BG = ""

var NEEDS_ESCAPE = [RED, STRONG]
var NEEDS_STAY = [GREEN]
var CLICKABLE = [RED, BLUE]

# Statistics + Flags

var FAILED = 0
var PASSED = 0
var HITS = 0

# Level names

var LEVELS = ["RED", "GREEN", "BLUE", "BLACK", "TOGETHER NOW", "DISORIENTATION", "PERMUTE", "REDIRECT", 
"REPULSION", "MAGENTA!!", "ASCENT", "VORTEX", "ASCENT II", "DUAL", "COLUMNS", "CONFINEMENT", 
"ABYSS", "WIRE", "COSMO", "CIRCUIT", "MERSENNE", "ORBIT", "PRISM", "SPECTRUM"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TL = get_viewport().size * -1
	BR = get_viewport().size * 2
	print(TL, BR)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var volume = (AudioServer.get_bus_peak_volume_left_db(0,0) + AudioServer.get_bus_peak_volume_right_db(0,0)) / 2
	if (volume == -200):
		VOLZEROTIMER += 1
	else:
		VOLZEROTIMER = 0
	
	if VOLZEROTIMER >= 30:
		volume = 0
	
	print(volume)
	
	# volume = specanal.get_magnitude_for_frequency_range(0, 10000).length()
	var normalized = sigmoid((volume + 60), 1.0 / 75.0)
	if (normalized < 0):
		normalized = 0
	elif (normalized > 1):
		normalized = 1
	VOLUME = normalized

# MATH / UTIL FUNCTIONS

func sigmoid(x, s): # Sigmoid with dy/dx = s @x = 0
	var res = 1 + exp(-2 * s * x)
	return (2.0 / res) - 1
	
func rotate(disp: Vector2, step):
	if (step == 1):
		return Vector2(-1 * disp.y, disp.x)
	if (step == 2):
		return Vector2(-1 * disp.x, -1 * disp.y)
	if (step == 3):
		return Vector2(disp.y, -1 * disp.x)
	else:
		return Vector2(disp.x, disp.y)
		
func clamp(x, L, H):
	if x < L:
		x = L
	elif x > H:
		x = H
		
	return x

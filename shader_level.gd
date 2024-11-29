class_name ShaderLevel
extends Level


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	$MarginContainer/ColorRect.material.shader = get_meta("SHADER")
	$MarginContainer/ColorRect.color = Color(1, 1, 1, 1)

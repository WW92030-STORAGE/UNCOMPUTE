extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.

func _on_enter_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/level_selection.tscn")
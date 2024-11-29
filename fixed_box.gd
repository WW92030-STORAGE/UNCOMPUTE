class_name FixedObject
extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# print(scale)
	$CollisionShape2D.global_scale = scale
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if GlobalVariables.FAILED or GlobalVariables.PASSED:
		# $CollisionShape2D/WHITE.set_scale(Vector2(1, 1) / 8)
		return
	var col = get_meta("COLOR")
	$CollisionShape2D/COLOR.set_modulate(col)
	$CollisionShape2D/WHITE.set_scale((Vector2(1, 1) / 5) * (0.1 + 0.9 * GlobalVariables.VOLUME))
	
	if (global_position.x > GlobalVariables.BR.x) or (global_position.y > GlobalVariables.BR.y):
		print("OOB - BR - " + str(self))
		queue_free()
	if (global_position.x < GlobalVariables.TL.x) or (global_position.y < GlobalVariables.TL.y):
		print("OOB - TL - " + str(self))
		queue_free()
	pass

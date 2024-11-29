class_name EscapeObject
extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# print(scale)
	set_mass(scale.x * scale.y) 
	# print(mass)
	can_sleep = false
	gravity_scale = 0
	applyGravity()
		
	$CollisionShape2D.scale = scale
	pass # Replace with function body.

func destroy():
	print("OUT OF BOUNDS - " + str(self) + " " + str(get_meta("COLOR")))
	if get_meta("COLOR") in GlobalVariables.NEEDS_STAY:
		GlobalVariables.FAILED = 1
	queue_free()

# Align gravity to the cardinal directions. 
# Gravity can go in any arbitrary direction however these ones are the most common and we want to mitigate errors.
func getalignment(v):
	var u = v.normalized()
	
	var EPSILON = 0.99
	
	var vecs = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0), Vector2(1, 1), Vector2(1, -1), Vector2(-1, -1), Vector2(-1, 1)]
	for vec in vecs:
		if (u.dot(vec.normalized()) >= EPSILON):
			u = vec.normalized()
	
	return u * v.length()

func getGravity():
	var gravnorm = ProjectSettings.get_setting("physics/2d/default_gravity")
	var gravgrav = Vector2(0, mass) * gravnorm
	gravgrav = gravgrav.rotated(get_meta("GRAV"))
	gravgrav = getalignment(gravgrav)
	# print(gravgrav)
	return gravgrav
	
func applyGravity():
	constant_force = Vector2(0, 0)
	var gravgrav = getGravity()
	
	add_constant_central_force(gravgrav)

# Called every frame. 'delta' is the elapsed time since the previous frame.
var count = 0
func _physics_process(delta: float) -> void:
	if GlobalVariables.FAILED or GlobalVariables.PASSED:
		# $CollisionShape2D/Grav.set_scale(Vector2(1, 1) / 32)
		freeze = true
		return
		
	var col = get_meta("COLOR")
	$CollisionShape2D/COLOR.set_modulate(col)
	$Grav.set_global_rotation(get_meta("GRAV") + PI * 0.75)
	var scalemin = min(global_scale.x, global_scale.y)
	$Grav.set_global_scale((Vector2(1, 1) / 8) * (0.1 + 0.9 * GlobalVariables.VOLUME) * scalemin)

	
	if (global_position.x > GlobalVariables.BR.x) or (global_position.y > GlobalVariables.BR.y):
		destroy()
	if (global_position.x < GlobalVariables.TL.x) or (global_position.y < GlobalVariables.TL.y):
		destroy()
	pass

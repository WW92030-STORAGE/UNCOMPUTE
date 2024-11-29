class_name Player
extends RigidBody2D

func getGravity():
	var gravnorm = ProjectSettings.get_setting("physics/2d/default_gravity")
	var gravgrav = Vector2(0, mass) * gravnorm
	gravgrav = gravgrav.rotated(get_meta("GRAV"))
	gravgrav = getalignment(gravgrav)
	return gravgrav
	
func applyGravity():
	constant_force = Vector2(0, 0)
	var gravgrav = getGravity()
	
	add_constant_central_force(gravgrav)
	
func getalignment(v):
	var u = v.normalized()
	
	var EPSILON = Vector2(0, 1).dot(Vector2(0, 1).rotated(0.01))
	
	var vecs = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0), Vector2(1, 1), Vector2(1, -1), Vector2(-1, -1), Vector2(-1, 1)]
	for vec in vecs:
		if (u.dot(vec.normalized()) >= EPSILON):
			u = vec.normalized()
	
	return u * v.length()

func destroy():
	print("OUT OF BOUNDS - " + str(self) + " " + str(get_meta("COLOR")))
	GlobalVariables.FAILED = true
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(scale)
	set_mass(scale.x * scale.y) 
	print(mass)
	can_sleep = false
	gravity_scale = 0
	applyGravity()
		
	$CollisionShape2D.scale = scale

var IS_ON_FLOOR = 0

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var grav = getGravity().normalized()
	var i := 0
	var EPSILON = 0.01
	
	IS_ON_FLOOR = 0
	
	# Lateral movement
	var FORCE_SCALE = 0.5
	var direction = Input.get_axis("ui_left", "ui_right")
	# print(direction)
	if direction:
		state.apply_force(direction * FORCE_SCALE * getGravity().rotated(-PI / 2))
	
	while i < state.get_contact_count():
		var normal := state.get_contact_local_normal(i)
		IS_ON_FLOOR = IS_ON_FLOOR or normal.dot(-1 * grav) > EPSILON # this can be dialed in
		#  1.0 would be perfectly straight up
		#  0.0 is a wall
		# -1.0 is a ceiling
		i += 1

func isOnFloor():
	return IS_ON_FLOOR
	var grav = getGravity().normalized()
	for body in get_colliding_bodies():
		print(body)
		return true
	return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if GlobalVariables.FAILED or GlobalVariables.PASSED:
		return
		
	var JUMP_SCALE = 0.5
	
	applyGravity()
		
		# Handle Jump.
	if Input.is_action_just_pressed("UP"):
		print(isOnFloor())
		if isOnFloor():
			apply_central_impulse(-JUMP_SCALE * getGravity())
	
	# Out of bounds
	if (global_position.x > GlobalVariables.BR.x) or (global_position.y > GlobalVariables.BR.y):
		destroy()
	if (global_position.x < GlobalVariables.TL.x) or (global_position.y < GlobalVariables.TL.y):
		destroy()
	
	$Grav.set_global_rotation(get_meta("GRAV") + PI * 0.75)
	var scalemin = min(global_scale.x, global_scale.y)
	$Grav.set_global_scale((Vector2(1, 1) / 8) * (0.1 + 0.9 * GlobalVariables.VOLUME) * scalemin)
	
		
	var pp = false
	for obj in $Area2D.get_overlapping_areas():
		if obj.is_in_group("PLAYER_END"):
			pp = true
	
	var EPSILON = 1e-2
	if (linear_velocity.length() > EPSILON):
		pp = false
			
	set_meta("PASSING", pp)
	

class_name Level
extends Node2D

# Statistics/Constants

var passtimer = 0

# Asset loads

var PASS_SFX = preload("res://611111__5ro4__bell-ding-3.wav")
var FAIL_SFX = preload("res://3536__luffy__record-scratch.wav")
var RES_PLAYED = false

var TOTAL_TIME = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	GlobalVariables.HITS = 0
	GlobalVariables.FAILED = 0
	GlobalVariables.PASSED = 0
	
	GlobalVariables.START_TIME = Time.get_ticks_msec()
	
	if GlobalVariables.BG != "":
		$BGElement.set_meta("IMAGE_TEXTURE", load(GlobalVariables.BG))

var DEBUG = false

func checkvalid():
	var EPSILON = 0.01
	if GlobalVariables.FAILED:
		return 0
	for objects in get_tree().get_nodes_in_group("RIGIDBODY"):
		if objects is RigidBody2D:
			if objects.get_meta("COLOR") in GlobalVariables.NEEDS_ESCAPE:
				if (DEBUG):
					print("NOT ELIMINATED", objects)
				return 0
			if objects.linear_velocity.length() > EPSILON:
				if (DEBUG):
					print("TOO FAST", objects)
				return 0
	for objects in get_tree().get_nodes_in_group("FIXEDBODY"):
		if objects is StaticBody2D:
			if objects.get_meta("COLOR") in GlobalVariables.NEEDS_ESCAPE:
				if (DEBUG):
					print("NOT ELIMINATED STATIC", objects)
				return 0
	for objects in get_tree().get_nodes_in_group("PLAYER"):
		if not objects.get_meta("PASSING"):
			return 0
	
	# Passed stats
	
	TOTAL_TIME = (Time.get_ticks_msec() - GlobalVariables.START_TIME) * 0.001
	
	return 1

func setStats():
	$PASSED/VBoxContainer/NCLICKS.text = str(GlobalVariables.HITS) + " CLICKS-" + str(TOTAL_TIME) + " SEC"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$FAILED.visible = GlobalVariables.FAILED
	$PASSED.visible = GlobalVariables.PASSED
	
	setStats()
	
	if GlobalVariables.FAILED or GlobalVariables.PASSED:
		if not RES_PLAYED:
			if GlobalVariables.PASSED:
				$AudioStreamPlayer2D.stream = PASS_SFX
				$AudioStreamPlayer2D.play(0.08)
			elif GlobalVariables.FAILED:
				$AudioStreamPlayer2D.stream = FAIL_SFX
				$AudioStreamPlayer2D.play(6.5)
			RES_PLAYED = true
		return
	
	if checkvalid():
		passtimer += 1
		if passtimer >= GlobalVariables.PASS_THRESH:
			GlobalVariables.PASSED = true
	else:
		passtimer = 0
		

	
func _input(event):
	if GlobalVariables.FAILED or GlobalVariables.PASSED:
		if Input.is_action_just_pressed("RESET"):
			get_tree().reload_current_scene()
		elif Input.is_action_just_pressed("BACKTOMENU"):
			get_tree().change_scene_to_file("res://menu/level_selection.tscn")
		return
	if Input.is_action_just_pressed("RESET2"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("QUIT2"):
		get_tree().change_scene_to_file("res://menu/level_selection.tscn") 
	if event is InputEventMouseButton and event.pressed == true:
		var bi = event.button_index
		if bi == MOUSE_BUTTON_LEFT:
			var query = PhysicsPointQueryParameters2D.new()
			query.position = event.position
			var vv = get_world_2d().direct_space_state.intersect_point(query)
			print(vv)
			
			for v in vv:
				var object = v["collider"]
				var col = object.get_meta("COLOR")
				if col in GlobalVariables.CLICKABLE:
					object.queue_free()
					GlobalVariables.HITS += 1

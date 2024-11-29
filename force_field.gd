class_name ForceField
extends CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var TRIX_SCL = 2.0
	var SCL = scale * 16 / TRIX_SCL
	var GRAV = get_meta("GRAV") + PI * 0.75
	GRAV = floor(GRAV / (PI / 2)) * (PI / 2)
	$Sprite2D.global_scale = Vector2(1, 1)
	$Sprite2D.global_rotation = GRAV
	$Sprite2D.global_scale = Vector2(1, 1) * TRIX_SCL
	$Sprite2D.region_rect = Rect2(-SCL.x, -SCL.y, SCL.x, SCL.y) * Transform2D(-GRAV, Vector2(0, 0))
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	$Sprite2D.modulate = Color(1, 1, 1, 0.25)
	
	for obj in $Area2D.get_overlapping_bodies():
		# print(obj)
		if obj.is_in_group("PLAYER") or obj.is_in_group("RIGIDBODY"):
			# print("!!!")
			obj.set_meta("GRAV", get_meta("GRAV"))
			obj.applyGravity()

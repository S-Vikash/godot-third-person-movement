extends CharacterBody3D

@export var spring_arm_pivot: Node3D
@export var player_body: MeshInstance3D

@export var jump_height: float = 2.0
@export var move_speed: float = 5.0
@export var turn_speed: float = 5.0

var gravity: float = -9.8
var jump_vel: float = sqrt(-2.0 * gravity * jump_height)
	

func _physics_process(delta: float) -> void:
	jump(delta)
	move(delta)

func move(delta):
	# Input
	var input_dir:Vector3 #= Vector3.ZERO
	input_dir.x = Input.get_axis("Left", "Right")
	input_dir.z = Input.get_axis("Forward", "Back")

	# Move relative to camera
	var move_dir: Vector3 #= Vector3.ZERO
	if input_dir.length() > 0.1:
		move_dir = spring_arm_pivot.global_basis * input_dir
		move_dir.y = 0.0
		move_dir = move_dir.normalized()

		# Move character
		velocity.x = move_dir.x * move_speed
		velocity.z = move_dir.z * move_speed

		# Face movement direction
		var target_basis := Basis.looking_at(move_dir, Vector3.UP)  #Vector3.UP indicates rotate around y_axis,horz rot
		player_body.global_basis = player_body.global_basis.slerp(
			target_basis,
			turn_speed * delta
		)
	
	else:
		# Stop horizontal movement when no input   In if codn velocity is set, here it is reset
		velocity.x = move_toward(velocity.x, 0.0, move_speed)
		velocity.z = move_toward(velocity.z, 0.0, move_speed)

	move_and_slide()

func jump(delta:float):
	if not is_on_floor():
		velocity.y += gravity * delta		#Apply gravity if not grounded, frame independent
	else:
		velocity.y = 0.0
		if Input.is_action_just_pressed("Jump"):
			velocity.y = jump_vel

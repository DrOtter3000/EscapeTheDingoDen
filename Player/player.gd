extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var flashlight: SpotLight3D = $CameraPivot/Camera3D/Flashlight
@onready var target_ray_cast: RayCast3D = $CameraPivot/Camera3D/TargetRayCast

@export var max_hitpoints : int = 100
@export var damage := 10

var mouse_motion := Vector2.ZERO
var fall_multiplier := 2.0
var hitpoints := max_hitpoints:
	set(value):
		hitpoints = value
		print(hitpoints)


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	flashlight.light_energy = 0


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("flashlight"):
		if flashlight.light_energy > 0:
			flashlight.light_energy = 0
		else:
			flashlight.light_energy = 1.0
	
	if Input.is_action_just_pressed("fire"):
		var target = target_ray_cast.get_collider()
		shoot(target)

func _physics_process(delta: float) -> void:
	turn_player()
	# Add the gravity.
	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * delta * fall_multiplier

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_motion = -event.relative * 0.002


func turn_player() -> void:
	rotate_y(mouse_motion.x)
	$CameraPivot.rotate_x(mouse_motion.y)
	$CameraPivot.rotation_degrees.x = clampf($CameraPivot.rotation_degrees.x, -90, 90)
	mouse_motion = Vector2.ZERO


func shoot(body) -> void:
	if body.is_in_group("Enemies"):
		body.take_damage(damage)

extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var player
@export var detection_range := 10.0
@export var attack_range := 2.0
@export var damage := 5
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D


@export var max_hitpoints := 100

var hitpoints := max_hitpoints:
	set(value):
		hitpoints = value
		print(hitpoints)
		if hitpoints <= 0:
			queue_free()

var provoked := false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


func _process(delta: float) -> void:
	if provoked:
		navigation_agent_3d.target_position = player.global_position


func _physics_process(delta: float) -> void:
	var next_position = navigation_agent_3d.get_next_path_position()
	var distance = global_position.distance_to(player.global_position)
	
	if distance < detection_range:
		provoked = true
	
	if distance < attack_range:
		#animation_player.play("attack")
		pass
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var direction := global_position.direction_to(next_position)
	
	if direction:
		look_at_target(direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func look_at_target(direction: Vector3):
	var adjusted_direction = direction
	adjusted_direction.y = 0
	look_at(global_position + adjusted_direction, Vector3.UP, true)


func hurt_player() -> void:
	player.hitpoints -= damage


func take_damage(value) -> void:
	hitpoints -= value
	provoked = true

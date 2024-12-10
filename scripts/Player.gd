class_name Player extends CharacterBody3D

@export_category("Player")
@export_range(1, 35, 1) var speed: float = 10 # m/s
@export_range(10, 400, 1) var acceleration: float = 100 # m/s^2

@export_range(0.1, 3.0, 0.1, "or_greater") var camera_sens: float = 1

var mouse_captured: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim

var walk_vel: Vector3 # Walking velocity 

var held_object

var pull_force = 10

@onready var interaction = $Camera/interaction
@onready var hand = $Camera/hand
@onready var camera: Camera3D = $Camera

func _ready() -> void:
	#Capture Mouse on start
	capture_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
	#Check if the mouse is captured
	#to see if need to rotate the camera
	if mouse_captured: 
		_rotate_camera()
	# Binding to exit game
	if Input.is_action_just_pressed("exit"): 
		get_tree().quit()
	# Binding to pull up settings menu
	if Input.is_action_just_pressed("settings"):
		$"../Settings".visible = !$"../Settings".visible 
		release_mouse()
	# Binding to pickup/release object
	if Input.is_action_just_pressed("pickup"):
		if held_object == null:
			pick_up_object()
		elif held_object != null:
			drop_object()

func _physics_process(delta: float) -> void:
	# Get the vector for walking
	velocity = _walk(delta)
	#Use for collisions
	move_and_slide()
	if held_object != null:
		var a = held_object.global_transform.origin
		var b = hand.global_transform.origin
		held_object.set_linear_velocity((b-a)*pull_force)

func capture_mouse() -> void:
	#Capture the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

func _walk(delta: float) -> Vector3:
	# Get our movement vector from input
	move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	#Get the forward vector by 
	#getting the camera direction then dot 
	#it with the input direction
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	#Next normalize the forward vector without y direction
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	#Then do a move toward our new vector, accounting for speed and acceleration
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel


func _on_exit_pressed() -> void:
	#Once we hit the exit button in the menu,
	#we recapture the mouse
	capture_mouse()
	#make the settings menu not visible.
	$"../Settings".visible = !$"../Settings".visible 

func pick_up_object():
	# Look for a collision from interaction ray
	var collider = interaction.get_collider()
	#Check if the collision is a RigidBody(our sword)
	# it won't pick up the ground as it is a static body
	if collider != null and collider is RigidBody3D:
		#Set the sword to what we are holding
		held_object = collider
		
func drop_object():
	#Remove the object from what we our holding
	#The physics process wont interact to with
	#the object anymore
	if held_object != null:
		held_object = null

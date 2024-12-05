extends RigidBody3D

var previous_state = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_check_button_toggled(toggled_on: bool) -> void:
	previous_state = !previous_state
	$Sword/Fire.process_material.turbulence_enabled = previous_state
	$Sword/Smoke.process_material.turbulence_enabled = previous_state

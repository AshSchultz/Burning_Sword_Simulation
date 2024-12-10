extends RigidBody3D

var previous_state = false

func _on_check_button_toggled(toggled_on: bool) -> void:
	# Set the parameter on the fire and smoke particles
	$Sword/Fire.process_material.turbulence_enabled = toggled_on
	$Sword/Smoke.process_material.turbulence_enabled = toggled_on

extends RigidBody3D

var previous_state = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_check_button_toggled(toggled_on: bool) -> void:
	$Sword/Fire.process_material.turbulence_enabled = toggled_on
	$Sword/Smoke.process_material.turbulence_enabled = toggled_on

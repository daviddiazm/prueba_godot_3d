extends RigidBody3D

@onready var twist_pivot := $twistPivot
@onready var pitch_pivot := $twistPivot/pitchPivot

var mouse_sesiblitity := 0.001
var twist_input := 0.00
var pitch_input := 0.00

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta: float) -> void:
	var input = Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_backward")
	#input.y = Input.get_axis("move_jump")

	var inputJump = Input.get_action_strength("move_jump")
	apply_central_force(inputJump * Vector3.UP * 1200 * delta)
	
	print(twist_pivot.basis * input)
	apply_central_force(twist_pivot.basis * input * 1200 * delta)
	
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp( 
		pitch_pivot.rotation.x, 
		deg_to_rad(-30), 
		deg_to_rad(30)
	)
	twist_input = 0.0
	pitch_input = 0.0
	
	
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)




func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = event.relative.x * mouse_sesiblitity
			pitch_input = event.relative.y * mouse_sesiblitity

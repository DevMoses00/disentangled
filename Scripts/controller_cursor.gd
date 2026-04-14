extends Node

# Speed in pixels/second at full stick deflection (viewport is 1920x1080)
const CURSOR_SPEED := 900.0
const DEADZONE := 0.2

var controller_active := false


func _ready() -> void:
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	controller_active = Input.get_connected_joypads().size() > 0
	if controller_active:
		get_viewport().warp_mouse(Vector2(960, 540))


func _on_joy_connection_changed(_device: int, _connected: bool) -> void:
	controller_active = Input.get_connected_joypads().size() > 0


func _process(delta: float) -> void:
	if not controller_active:
		return

	var raw := Vector2(
		Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	)

	var length := raw.length()
	if length < DEADZONE:
		return

	# Remap so motion starts right at the deadzone edge
	var stick := raw.normalized() * ((length - DEADZONE) / (1.0 - DEADZONE))

	var viewport := get_viewport()
	var new_pos := viewport.get_mouse_position() + stick * CURSOR_SPEED * delta
	new_pos = new_pos.clamp(Vector2.ZERO, viewport.get_visible_rect().size)
	viewport.warp_mouse(new_pos)


func _input(event: InputEvent) -> void:
	if not controller_active:
		return

	# Bottom button (A / Cross) → simulate a left mouse click at the cursor
	if event is InputEventJoypadButton and event.button_index == JOY_BUTTON_A:
		var pos := get_viewport().get_mouse_position()

		var mouse_event := InputEventMouseButton.new()
		mouse_event.button_index = MOUSE_BUTTON_LEFT
		mouse_event.pressed = event.pressed
		mouse_event.position = pos
		mouse_event.global_position = pos

		Input.parse_input_event(mouse_event)

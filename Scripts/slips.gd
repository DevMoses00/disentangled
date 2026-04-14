extends Area2D

var moveable = false
var is_dragging = false
var drag_offset = Vector2()


func _ready():
	set_process_input(true)


func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Select") and moveable:
		is_dragging = true
		var select = ["SM_1","SM_2","SM_3","SM_4","SM_5"].pick_random()
		SoundManager.play_sfx(select)
		drag_offset = global_position - get_global_mouse_position()
		SlipManager.lock(self)
	if event.is_action_released("Select"):
		is_dragging = false


func _input(event):
	# Once dragging, follow the cursor regardless of whether it left the area
	if is_dragging:
		global_position.y = get_global_mouse_position().y + drag_offset.y


func _process(delta):
	pass


func _on_mouse_entered() -> void:
	SlipManager.on_slip_entered(self)


func _on_mouse_exited() -> void:
	SlipManager.on_slip_exited(self)
	# Only stop an in-progress drag if we're not locked (locked slip can be
	# re-grabbed after cursor re-enters)
	if SlipManager.locked_slip != self:
		is_dragging = false

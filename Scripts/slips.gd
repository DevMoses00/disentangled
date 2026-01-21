# Example script for an Area2D
extends Area2D

var moveable = false
var is_dragging = false
var drag_offset = Vector2() # To prevent snapping to mouse center



func _ready():
	# Ensure the node can receive input events
	set_process_input(true)


func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Select") and moveable:
		is_dragging = true
		var select = ["SM_1","SM_2","SM_3","SM_4","SM_5"].pick_random()
		SoundManager.play_sfx(select)
		if is_dragging:
			drag_offset = global_position - get_global_mouse_position()
			## Optional: Bring to front (higher Z-index)
			#get_parent().move_child(self, get_parent().get_child_count() - 1)
			print("Drag Started")
	if event.is_action_released("Select"):
		is_dragging = false
	
func _input(event): # Or use _unhandled_input for gameplay elements [3]
	if is_dragging and moveable:
		# --- THE KEY: Only update the desired axis ---
		# For horizontal drag:
		#global_position.x = get_global_mouse_position().x + drag_offset.x
		# For vertical drag:
		global_position.y = get_global_mouse_position().y + drag_offset.y
		
func _process(delta):
	# Optional: If using _unhandled_input for movement, you might move the node here
	# if is_dragging:
	#     position = get_global_mouse_position() + drag_offset # This would drag in all directions
	pass


func _on_mouse_entered() -> void:
	moveable = true
	self.scale = Vector2(0.99,0.99)


func _on_mouse_exited() -> void:
	moveable = false
	is_dragging = false
	self.scale = Vector2(1,1)

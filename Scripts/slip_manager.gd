extends Node

# The slip the cursor is currently over (only the top-most one is ever active)
var entered_slips: Array = []
# The slip the player has grabbed - no other slip can be selected until it leaves
var locked_slip: Node = null


func on_slip_entered(slip: Node) -> void:
	# While a different slip is locked, ignore all others
	if locked_slip != null and locked_slip != slip:
		return
	if slip not in entered_slips:
		entered_slips.append(slip)
	_refresh()


func on_slip_exited(slip: Node) -> void:
	entered_slips.erase(slip)
	# If this is the locked slip leaving our cursor, keep moveable so it
	# can still be re-grabbed — but if it's just an unlocked slip, deactivate it
	if slip != locked_slip:
		slip.moveable = false
		slip.scale = Vector2(1.0, 1.0)
	_refresh()


func lock(slip: Node) -> void:
	locked_slip = slip
	# Deactivate every other slip that happens to be entered
	for s in entered_slips:
		if s != slip:
			s.moveable = false
			s.scale = Vector2(1.0, 1.0)


func release_lock(slip: Node) -> void:
	if locked_slip == slip:
		locked_slip = null
	entered_slips.erase(slip)
	_refresh()


func _refresh() -> void:
	if locked_slip != null:
		# Only the locked slip may be highlighted
		for s in entered_slips:
			var active := s == locked_slip
			s.moveable = active
			s.scale = Vector2(0.99, 0.99) if active else Vector2(1.0, 1.0)
		return

	var top := _get_top_slip()
	for s in entered_slips:
		var active := s == top
		s.moveable = active
		s.scale = Vector2(0.99, 0.99) if active else Vector2(1.0, 1.0)


# Top-most = highest z_index, tie-broken by scene-tree order (later = on top)
func _get_top_slip() -> Node:
	if entered_slips.is_empty():
		return null
	var top: Node = entered_slips[0]
	for s in entered_slips:
		if s.z_index > top.z_index:
			top = s
		elif s.z_index == top.z_index and s.get_index() > top.get_index():
			top = s
	return top

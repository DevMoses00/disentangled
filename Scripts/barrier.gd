extends Area2D

@export var hands : AnimatedSprite2D

@export var tween_distance := 10000.0
@export var tween_time := 0.3
@export var strips_inside := 12

var exit_hands = 2

signal all_strips_exited

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hands.frame = 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



#func _on_body_exited(body: Node2D) -> void:
	#if not body.is_in_group("strips"):
		#return
	#
	#print("body_exiting")
	#var local_pos = to_local(body.global_position)
	#var exit_dir := Vector2.ZERO
	#
	## Decide which side was crossed
	#if abs(local_pos.x) > abs(local_pos.y):
		## Left or Right
		#exit_dir.x = sign(local_pos.x)
	#else: 
		## Top or Bottom
		#exit_dir.y = sign(local_pos.y)
	#
	#_tween_strip_out(body, exit_dir)


func _tween_strip_out(strip: Node2D, direction: Vector2):
	var tween := get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	var slide = ["Slide_1","Slide_2","Slide_3"].pick_random()
	SoundManager.play_sfx(slide)
	
	var target_pos = strip.global_position + direction * tween_distance
	
	tween.tween_property(strip, "global_position", target_pos, tween_time)
	await tween.finished
	
	strip.queue_free()


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("hands"):
		print("hand_leave")
		var local_pos = to_local(area.global_position)
		var exit_dir := Vector2.ZERO
		
		# Decide which side was crossed
		if abs(local_pos.x) > abs(local_pos.y):
			# Left or Right
			exit_dir.x = sign(local_pos.x)
		else: 
			# Top or Bottom
			exit_dir.y = sign(local_pos.y)
		_tween_strip_out(area, exit_dir)
		
		exit_hands -= 1
		
		if exit_hands == 0:
			SoundManager.play_mfx("Keys_3")
			SoundManager.fade_out("BG_1",2.0)
			SoundManager.fade_out("Beach_Loop",2.0)
			await get_tree().create_timer(5).timeout
			$Black.show()
			await get_tree().create_timer(7).timeout
			get_tree().change_scene_to_file("res://Scenes/intro.tscn")
		
		return
		
		
		
	
	print("body_exiting")
	var local_pos = to_local(area.global_position)
	var exit_dir := Vector2.ZERO
	
	# Decide which side was crossed
	if abs(local_pos.x) > abs(local_pos.y):
		# Left or Right
		exit_dir.x = sign(local_pos.x)
	else: 
		# Top or Bottom
		exit_dir.y = sign(local_pos.y)
	
	_tween_strip_out(area, exit_dir)
	
	# remove the strip from strips inside counter:
	strips_inside -= 1
	area.monitoring = false
	
	if strips_inside == 8: 
		hands.frame = 1
	
	if strips_inside == 4: 
		hands.frame = 2
	
	if strips_inside == 1: 
		hands.frame = 3
	
	if strips_inside <= 0:
		strips_inside = 0
		emit_signal("all_strips_exited")

extends Node2D

var show_counter = 0

var puzzle_instance: PackedScene = preload ("res://Scenes/puzzle_space.tscn")
var current_instance_node: Node2D

var sequence_level = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_bgs("Beach_Loop",0,5)
	await get_tree().create_timer(4).timeout
	fade_tween_out($TextureRect)
	await get_tree().create_timer(2).timeout
	SoundManager.play_sfx("SH_1",0,10)
	$Logo.show()
	await get_tree().create_timer(6).timeout
	# SoundManager.play_sfx(sound)
	$Logo.hide()
	SoundManager.fade_in_bgm("BG_1",1.0)
	await get_tree().create_timer(4).timeout
	camera_init()


func signals_connect():
	current_instance_node.show_phase.connect(show_full_images)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene_to_file("res://Scenes/intro.tscn")

func camera_init():
	var tween = create_tween()
	tween.tween_property($Camera2D,"zoom",Vector2(2.8,2.8),13).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property($Camera2D,"position:y",-100,13).as_relative()
	await tween.finished
	await get_tree().create_timer(1.5).timeout
	$Title.show()
	SoundManager.play_sfx("SH_2",0,10)
	await get_tree().create_timer(1).timeout
	$Title2.show()
	SoundManager.play_sfx("SH_3",0,10)
	await get_tree().create_timer(4).timeout
	$Title.hide()
	$Title2.hide()
	print("into the next section")
	sequence_one()

func sequence_one():
	await get_tree().create_timer(2).timeout
	# do this to allow the fade tweens to work properly - just remember to set it off once faded back in
	$M.use_parent_material = true
	$J.use_parent_material = true
	await get_tree().create_timer(0.1).timeout
	# This is how we enter the first puzzle sequence
	fade_tween_out($M)
	fade_tween_out($J)
	var tween = create_tween()
	tween.tween_property($Camera2D,"zoom",Vector2(1.6,1.6),4).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property($Camera2D,"position:y",0,4)
	await tween.finished
	$JFull.hide()
	$MFull.hide()
	# create the new puzzle instance
	create_new_puzzle_instance()
	signals_connect()
	await get_tree().create_timer(2).timeout
	# fade in hands
	# fade_tween_in($Hands)
	#fade_tween_in($PuzzleSpace)
	fade_tween_in(current_instance_node)
	SoundManager.play_mfx("Keys_2")
	await get_tree().create_timer(2).timeout
	var hands = current_instance_node.find_child("Hands")
	hands.use_parent_material = false
	# fade in puzzle strips depending on which level it is
	pass

func seq_lev(sequence):
	if sequence == 1:
		for child in current_instance_node.get_children():
			if child.is_in_group("strips"):
				var A = child.find_child("A")
				A.show()
				var B = child.find_child("B")
				B.hide()
				var C = child.find_child("C")
				C.hide()
	elif sequence == 2:
		for child in current_instance_node.get_children():
			if child.is_in_group("strips"):
				var A = child.find_child("A")
				A.hide()
				var B = child.find_child("B")
				B.show()
				var C = child.find_child("C")
				C.hide()
	elif sequence == 3:
		for child in current_instance_node.get_children():
			if child.is_in_group("strips"):
				var A = child.find_child("A")
				A.hide()
				var B = child.find_child("B")
				B.hide()
				var C = child.find_child("C")
				C.show()

func show_full_images():
	print("signal_starting")
	# fade the characters back in
	fade_tween_in($M)
	fade_tween_in($J)
	await get_tree().create_timer(2).timeout
	$M.use_parent_material = false
	$J.use_parent_material = false
	# zoom out the camera
	zoom_cam_out()
	$MFull.show()
	$JFull.show()
	show_counter += 1
	if show_counter == 1:
		# show the first set of images
		$MFull.play("A")
		$MFull/Layer1.play("A")
		$MFull/Layer2.play("A")
		$JFull.play("A")
		$JFull/Layer1.play("A")
		$JFull/Layer2.play("A")
		await get_tree().create_timer(1).timeout
		SoundManager.fade_into_bgm("BG_2","BG_1",2.0)
	elif show_counter == 2:
		$MFull.play("B")
		$MFull/Layer1.play("B")
		$MFull/Layer2.play("B")
		$JFull.play("B")
		$JFull/Layer1.play("B")
		$JFull/Layer2.play("B")
		await get_tree().create_timer(1).timeout
		SoundManager.fade_into_bgm("BG_3","BG_2",2.0)
	elif show_counter == 3:
		# show third set of images, wait and go to end sequence
		$MFull.play("C")
		$MFull/Layer1.play("C")
		$MFull/Layer2.play("C")
		$JFull.play("C")
		$JFull/Layer1.play("C")
		$JFull/Layer2.play("C")
		# Change to next track
		await get_tree().create_timer(6).timeout
		SoundManager.fade_into_bgm("BG_1","BG_3",5.0)
		fade_tween_in($TextureRect)
		await get_tree().create_timer(5).timeout
		# end sequence
		get_tree().change_scene_to_file("res://Scenes/end.tscn")
		return
	
	await get_tree().create_timer(5).timeout
	# repeat sequence
	sequence_one()





# HELPER FADES
func fade_tween(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)
	fadeTween.tween_interval(3)
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 0.0), 2)
	fadeTween.bind_node(self)
func fade_tween_in(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)
	fadeTween.bind_node(self)
func fade_tween_out(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 0.0), 2)
	fadeTween.bind_node(self)

func zoom_cam_out():
	var tween = create_tween()
	tween.tween_property($Camera2D,"zoom",Vector2(1,1),4).set_ease(Tween.EASE_IN_OUT)
	#tween.parallel().tween_property($Camera2D,"position:y",100,4).as_relative()

func create_new_puzzle_instance():
	current_instance_node = puzzle_instance.instantiate()
	current_instance_node.scale = Vector2(0.37,0.37)
	current_instance_node.modulate = Color(1,1,1,0)
	# Determine which version of the puzzle you're showing
	sequence_level += 1
	seq_lev(sequence_level)
	#add the child
	add_child(current_instance_node)

extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade_tween_out($TextureRect)
	await get_tree().create_timer(2).timeout
	fade_tween_in($M_Folder)
	fade_tween_in($J_Folder)
	await get_tree().create_timer(2).timeout
	$M_Folder/M.use_parent_material = false
	$J_Folder/J.use_parent_material = false
	await get_tree().create_timer(5).timeout
	disperse()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene_to_file("res://Scenes/intro.tscn")

func disperse():
	tween_cross()
	tween_right($M_Folder/MFull)
	SoundManager.play_sfx("SM_1")
	await get_tree().create_timer(0.1).timeout
	SoundManager.play_sfx("SM_2")
	tween_left($J_Folder/JFull)
	
	await get_tree().create_timer(3).timeout
	tween_right($M_Folder/MFull2)
	SoundManager.play_sfx("SM_3")
	await get_tree().create_timer(0.1).timeout
	SoundManager.play_sfx("SM_4")
	tween_left($J_Folder/JFull2)
	await get_tree().create_timer(3).timeout
	tween_right($M_Folder/MFull3)
	SoundManager.play_sfx("SM_5")
	await get_tree().create_timer(0.1).timeout
	SoundManager.play_sfx("SM_2")
	tween_left($J_Folder/JFull3)
	await get_tree().create_timer(3).timeout
	


func fade_tween_in(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)
	fadeTween.bind_node(self)

func fade_tween_out(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 0.0), 2)
	fadeTween.bind_node(self)


func tween_left(image) -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(image,"position:x",-2000,6).as_relative()


func tween_right(image) -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(image,"position:x",2000,6).as_relative()

func tween_cross():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property($M_Folder/MCloseup,"position:x",2000,16).as_relative()
	tween.parallel().tween_property($J_Folder/JCloseup,"position:x",-2000,16).as_relative()
	await tween.finished
	$M_Folder/M.use_parent_material = true
	$J_Folder/J.use_parent_material = true
	fade_tween_out($M_Folder/M)
	fade_tween_out($J_Folder/J)
	print("end_hand")
	await get_tree().create_timer(2.0).timeout
	fade_tween_in($TextureRect)
	await get_tree().create_timer(4.0).timeout
	fade_tween_in($HM_Final)
	fade_tween_in($HJ_Final)
	await get_tree().create_timer(2.0).timeout
	$HM_Final.use_parent_material = false
	$HJ_Final.use_parent_material = false
	$End.show()
	$End2.show()

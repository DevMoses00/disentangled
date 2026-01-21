extends Node2D

signal show_phase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.all_strips_exited.connect(strips_done)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func strips_done():
	print("all done")
	$Hands.use_parent_material = true
	fade_tween_out(self)
	await get_tree().create_timer(3).timeout
	SoundManager.play_mfx("Keys_1")
	show_phase.emit()
	queue_free()

func fade_tween_out(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 0.0), 2)
	fadeTween.bind_node(self)

extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_tween()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func wave_tween():
	var tween = create_tween()
	tween.tween_property(self, "position:y", -400, 3).as_relative().set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", 400, 4).as_relative().set_ease(Tween.EASE_OUT)
	SoundManager.play_sfx("Waves",0,0)


func _on_wave_timer_timeout() -> void:
	wave_tween()

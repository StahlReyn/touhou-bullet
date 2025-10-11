extends AudioStreamPlayer2D

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and not playing:
		play()

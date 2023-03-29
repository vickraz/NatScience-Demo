extends AnimatedSprite

func _ready() -> void:
	playing = true
	frame = 0



func _on_AudioStreamPlayer_finished() -> void:
	queue_free()

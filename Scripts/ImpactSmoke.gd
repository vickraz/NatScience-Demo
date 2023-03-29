extends AnimatedSprite

func _ready() -> void:
	playing = true
	frame = 0


func _on_ImpactSmoke_animation_finished() -> void:
	queue_free()

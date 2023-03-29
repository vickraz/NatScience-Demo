extends Area2D


const EXPLOSION = preload("res://Scenes/Explosion.tscn")



func _on_ExplosiveBarrel_body_entered(body: Node) -> void:
	var e = EXPLOSION.instance()
	e.global_position = global_position + Vector2(0, -15)
	get_tree().get_root().add_child(e)
	if body is Player:
		body.enter_dead_state(true)
	queue_free()

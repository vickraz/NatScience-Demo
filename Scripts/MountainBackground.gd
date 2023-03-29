extends ParallaxBackground

class_name MovingBackground

onready var moving_layer = $ParallaxLayer2
export var moving_speed: int = 20


func _process(delta: float) -> void:
	moving_layer.motion_offset.x -= moving_speed * delta

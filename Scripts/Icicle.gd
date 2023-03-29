extends KinematicBody2D

const GRAVITY = 2000

onready var anim = $AnimatedSprite
onready var ray  = $RayCast2D
onready var area = $Area2D
onready var audio = $AudioStreamPlayer

var velocity = Vector2.DOWN

enum {IDLE, FALL, EXPLODE}
var state = IDLE

func _ready() -> void:
	anim.play("idle")

func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			if ray.is_colliding():
				var col = ray.get_collider()
				if col is Player:
					state = FALL
					ray.enabled = false
		FALL:
			velocity.y += GRAVITY * delta
			velocity = move_and_slide(velocity, Vector2.UP)
			if is_on_floor():
				state = EXPLODE
				audio.play()
				anim.play("explode")
				area.monitoring = false
		EXPLODE:
			pass




func _on_AnimatedSprite_animation_finished() -> void:
	if anim.animation == "explode":
		queue_free()


func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		body.enter_dead_state(true)

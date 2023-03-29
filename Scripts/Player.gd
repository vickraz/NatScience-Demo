extends KinematicBody2D
class_name Player

signal dead(distance)

onready var anim = $AnimationPlayer
onready var coyoteTimer = $CoyoteTimer
onready var downSlopeRay = $DownSlopeRay
onready var distanceText = $HUD/DistanceText
onready var runningParticles = $RunningParticles
onready var jumpBuffer = $JumpBuffer
onready var jumpSound = $JumpSound

const MAX_ACC = 350
const NORM_GRAVITY = 2000
const MIN_GRAVITY = 700
const MAX_GRAVITY = 4200
const JUMP_STRENGHT = -800
const MAX_HOLD_TIME = 0.4;
const follow_slope_const = PI/4

var gravity := NORM_GRAVITY
var max_speed = 420.0
var prevoius_y_vel = 0
var can_jump := true
var want_to_jump := false
var holding_jump := false
var hold_time := 0.0
var acc := 250.0


var velocity := Vector2.ZERO
var distance_traveled := 0.0

enum {RUNNING, AIR, DEAD}

var state = RUNNING

onready var start_x = global_position.x

var impact_scene = preload("res://Scenes/ImpactSmoke.tscn")
var death_particles = preload("res://Scenes/PlayerDeadParticles.tscn")

#Game loop: called by the engine 60x/ second.
func _physics_process(delta: float) -> void:
	match state:
		RUNNING: 
			_run_state(delta)
		AIR:
			_air_state(delta)
		DEAD:
			pass
	
	#Update distance_traveled and check if dead


####################### general help functions #################################

#Function that moves the player and calls other help functions
func _move_player(delta) -> void:
	prevoius_y_vel = velocity.y
	#Move player forward and add gravity + downslope movement
	
	
	#Moves the player
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN * 10,Vector2.UP,
										true, 4, deg2rad(50), true)
	
	_change_anim_speed_and_acc(velocity)


#Changes the animation speed and acc depeding on the current velocity
func _change_anim_speed_and_acc(velocity: Vector2) -> void:
	pass


#Checks if the player is currently on a downslope or not
func _on_down_slope() -> bool:
	return false



######################## state-functions #######################################

#Handles input and movement while grounded
func _run_state(delta: float) -> void:
	pass


#Handles input and movement while NOT grounded
func _air_state(delta: float) -> void:
	if Input.is_action_just_released("jump"):
		holding_jump = false
	
	if Input.is_action_just_pressed("jump") and can_jump:
		_enter_air_state(true)
	elif Input.is_action_just_pressed("jump"):
		want_to_jump = true
		jumpBuffer.start()
		
		
	if Input.is_action_pressed("ui_down"):
		gravity = MAX_GRAVITY
		holding_jump = false
		hold_time = 0.0
	elif not holding_jump:
		gravity = NORM_GRAVITY
	else:
		gravity = MIN_GRAVITY
		hold_time += delta
		if hold_time >= MAX_HOLD_TIME:
			holding_jump = false
			hold_time = 0.0
			
			
	_move_player(delta)
		
	if velocity.y > 0:
		anim.play("Fall")
	
	if is_on_floor():
		if want_to_jump:
			_enter_air_state(true)
		else:
			_enter_run_state()


########################## state-transitions ###################################

#Reseting variables and animations when transition from air to run
func _enter_run_state() -> void:
	anim.play("Run")
	runningParticles.emitting = true
	state = RUNNING
	holding_jump = false
	hold_time = 0.0
	can_jump = true 
	want_to_jump = false
	gravity = NORM_GRAVITY
	if prevoius_y_vel > 950 and not _on_down_slope():
		var particles = impact_scene.instance()
		particles.global_position = global_position + Vector2(5, 25)
		get_parent().add_child(particles)

#Reseting variables and animations when transition from run to air
func _enter_air_state(jumping: bool) -> void:
	if jumping:
		velocity.y = JUMP_STRENGHT
		can_jump = false
		holding_jump = true
		jumpSound.play()
	else:
		coyoteTimer.start()
	state = AIR
	anim.play("Jump")
	runningParticles.emitting = false


#transitions from alive to dead and sends signal to other nodes that the player is dead
func enter_dead_state(spawn_blood: bool) -> void:
	state = DEAD
	visible = false
	distanceText.visible = false
	if spawn_blood:
		var p = death_particles.instance()
		p.emitting  = true 
		p.one_shot = true
		p.global_position = global_position + Vector2(-22, -15)
		get_parent().add_child(p)
		yield(get_tree().create_timer(0.4), "timeout")
	
	emit_signal("dead", round(distance_traveled))


################################ Signals ########################################

#Signal from timer node in scene
func _on_CoyoteTimer_timeout() -> void:
	can_jump = false

#Signal from timer node in scene
func _on_JumpBuffer_timeout() -> void:
	want_to_jump = false

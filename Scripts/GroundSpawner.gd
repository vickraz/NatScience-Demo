extends Node2D

export var level = 1
export var path = "res://Scenes/GroundParts/Level"
export var number_of_parts = 11

onready var edge: Position2D = $Start/Edge
onready var player: Player = get_parent().get_node("Player")

func _ready() -> void:
	path = path + str(level) + "_"
	randomize()
	
func _process(_delta: float) -> void:
	if player.global_position.x > edge.global_position.x - 600:
		_spawn_ground()


func _spawn_ground() -> void:
	var number: int = randi() % number_of_parts
	var ground_scene = load(path + str(number) + ".tscn")
	var g = ground_scene.instance()
	g.global_position = Vector2(edge.global_position.x + rand_range(150, 220), 0)
	add_child(g)
	edge = g.get_node("Edge")

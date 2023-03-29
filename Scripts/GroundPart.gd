extends Node2D

class_name GroundPart



onready var edge = $Edge
onready var startEdge = $StartEdge
const PATH = "res://Scenes/GroundParts/"

const BARREL_SCENE = preload("res://Scenes/ExplosiveBarrel.tscn")

var player: Player

func _ready() -> void:
	randomize()
	player = get_parent().get_parent().get_node("Player")
	for node in get_children():
		if "Barrel" in node.name:
			var r = randi() % 2
			if r == 0:
				var b = BARREL_SCENE.instance()
				node.add_child(b)

func _process(_delta: float) -> void:
	if player:
		if edge.global_position.x < player.global_position.x - 500:
			queue_free()


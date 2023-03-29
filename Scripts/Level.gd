extends Node2D

class_name LevelScript


onready var player: Player = $Player
onready var camera = $Camera2D
onready var gameOverMenu = $GameOverMenu
onready var bgMusic = $BGMusic
onready var gameOverSound = $GameOverSound


func _ready() -> void:
	player.get_node("RemoteTransform2D").remote_path = camera.get_path()
	player.connect("dead", self, "_on_Player_dead")
	player.connect("dead", gameOverMenu, "_on_Player_dead")
	bgMusic.play()


#Connected from players signal when dead
func _on_Player_dead(distance) -> void:
	gameOverMenu.visible = true
	bgMusic.stop()
	if not gameOverSound.playing:
		gameOverSound.play()

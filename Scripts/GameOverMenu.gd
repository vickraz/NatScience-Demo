extends CanvasLayer

onready var infoText = $Control/MarginContainer/VBoxContainer/DistanceInfo

func _ready() -> void:
	visible = false

#Connected from parent
func _on_Player_dead(distance) -> void:
	infoText.text = "you ran: " + str(distance) + " m"
	

func _on_RestartButton_pressed() -> void:
	get_tree().reload_current_scene()


func _on_QuitButton_pressed() -> void:
	get_tree().quit()

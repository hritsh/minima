extends Node2D

func _on_Timer_timeout():
	skip()

func skip():
	get_tree().change_scene("res://Scenes/Main.tscn")

func _unhandled_key_input(event):
	if event.pressed and event.scancode == KEY_ENTER:
		skip()


func _on_Timer2_timeout():
	$Label.visible = true

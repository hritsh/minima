extends Node2D

func _ready():
	$BackgroundMusic.play()
	$CanvasModulate.visible = true
	$Player.speed = 0

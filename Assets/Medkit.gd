extends Area2D

var jeff
var inventory
var objective
onready var sound = get_tree().root.get_node("Root/Player/Collect")

func _ready():
	jeff = get_tree().root.get_node("Root/Jeff")
	inventory = get_tree().root.get_node("Root/HUD/Inventory")	
	objective = get_tree().root.get_node("Root/HUD/Objective")	

func _on_Medkit_body_entered(body):
	if body.name == "Player":
		get_tree().queue_delete(self)
		jeff.medkit_found = true
		inventory.animation = "medkit"
		sound.play()
		objective.text = "Objective: Get back to Jeff"

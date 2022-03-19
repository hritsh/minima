extends Area2D

var angela
var inventory
var objective
onready var sound = get_tree().root.get_node("Root/Player/Collect")

func _ready():
	angela = get_tree().root.get_node("Root/Angela")
	inventory = get_tree().root.get_node("Root/HUD/Inventory")	
	objective = get_tree().root.get_node("Root/HUD/Objective")	

func _on_Medkit_body_entered(body):
	if body.name == "Player":
		get_tree().queue_delete(self)
		angela.keycard_found = true
		inventory.animation = "two_cards"
		sound.play()
		objective.text = "Objective: Go back to Angela"

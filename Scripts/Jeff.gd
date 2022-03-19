extends StaticBody2D

enum QuestStatus { NOT_STARTED, STARTED, COMPLETED }
var quest_status = QuestStatus.NOT_STARTED
var dialogue_state = -1
var medkit_found = false

var dialoguePopup
var player
var camera
var progress
var inventory
var objective
onready var sound = get_tree().root.get_node("Root/Player/Collect")

func _ready():
	dialoguePopup = get_tree().root.get_node("Root/HUD/DialoguePopup")
	player = get_tree().root.get_node("Root/Player")
	camera = get_tree().root.get_node("Root/Player/Camera2D")
	progress = get_tree().root.get_node("Root/Player/Progress")
	inventory = get_tree().root.get_node("Root/HUD/Inventory")
	objective = get_tree().root.get_node("Root/HUD/Objective")
	
func talk(answer = ""):
	# Set dialoguePopup npc to You
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "You"
	camera.offset.y = 100
	objective.visible = false
	
	# Show the current dialogue
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				-1:
					# Update dialogue tree state
					dialogue_state = 0
					# Show dialogue popup
					dialoguePopup.dialogue = "What happened here? Why is this place empty?"
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.npc_name = "Jeff"
					dialoguePopup.dialogue = "Can’t you see my leg is bleeding? First, help me treat my leg."
					dialoguePopup.answers = "[A] OK, but how?"
					dialoguePopup.open()
				1:
					# Update dialogue tree state
					dialogue_state = 2
					# Show dialogue popup
					dialoguePopup.npc_name = "Jeff"
					dialoguePopup.dialogue = "You need to go to the meds above and get whatever can be useful. Argh! I will tell you everything then."
					dialoguePopup.answers = "[A] Fine, I'll do that"
					dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.STARTED
					objective.text = "Objective: Find a medkit in the room above"
					# Close dialogue popup
					dialoguePopup.close()
					camera.offset.y = 0
					objective.visible = true
				3:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					camera.offset.y = 0
					objective.visible = true
		QuestStatus.STARTED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.npc_name = "Jeff"
					dialoguePopup.dialogue = "Did you find anything?"
					if medkit_found:
						dialoguePopup.answers = "[A] Yes  [B] No"
					else:
						dialoguePopup.answers = "[A] No"
					dialoguePopup.open()
				1:
					if medkit_found and answer == "A":
						# Update dialogue tree state
						dialogue_state = 2
						# Show dialogue popup
						dialoguePopup.npc_name = "Jeff"
						dialoguePopup.dialogue = "What are you waiting for then?? Apply the med kit and help me! Argh!"
						dialoguePopup.answers = "[A] Apply Med Kit"
						dialoguePopup.open()
					else:
						# Update dialogue tree state
						dialogue_state = 3
						# Show dialogue popup
						dialoguePopup.npc_name = "Jeff"
						dialoguePopup.dialogue = "What are you doing then?? Go find something to help me!"
						dialoguePopup.answers = "[A] Alright, sorry"
						dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 1
					inventory.animation = "empty"
					progress.start("Applying MedKit")
					quest_status = QuestStatus.COMPLETED
					# Close dialogue popup
					dialoguePopup.close()
					camera.offset.y = 0
					objective.visible = true
					yield(get_tree().create_timer(3), "timeout")
					# Set Fiona's animation to "idle"
					$AnimatedSprite.play("idle")
					objective.visible = false	
					dialoguePopup.npc_name = "Jeff"
					dialoguePopup.dialogue = "Thanks for your help! Here's a keycard for the Control Center. I think you might need it."
					dialoguePopup.answers = "[A] Bye"
					dialoguePopup.open()
					objective.text = "Objective: Find a way to the exit"
					inventory.animation = "one_card"
					sound.play()
				3:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					camera.offset.y = 0
					objective.visible = true

		QuestStatus.COMPLETED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 4
					# Show dialogue popup
					dialoguePopup.npc_name = "Jeff"
					dialoguePopup.dialogue = "I'll meet you at the exit."
					dialoguePopup.answers = "[A] Bye"
					dialoguePopup.open()
				1:
					# Update dialogue tree state
					dialogue_state = 10
					# Show dialogue popup
					dialoguePopup.npc_name = "Jeff"
					dialoguePopup.dialogue = "Alright as promised. I’ll tell you everything I know."
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
				10:
					# Update dialogue tree state
					dialogue_state = 2
					# Show dialogue popup
					dialoguePopup.npc_name = "Jeff"
					dialoguePopup.dialogue = "I was working in the supply center in station B and I came to station A to get something and then I suddenly heard the alarms."
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 3
					# Show dialogue popup
					dialoguePopup.npc_name = "Jeff"
					dialoguePopup.dialogue = "The alarm was so loud that I lost my balance and some of the supply boxes fell on me injuring my leg. *sigh*"
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
				3:
					# Update dialogue tree state
					dialogue_state = 11
					# Show dialogue popup
					dialoguePopup.npc_name = "Jeff"
					dialoguePopup.dialogue = "I was shouting for help but nobody came for help. I assume everyone just rushed outside the station."
					dialoguePopup.answers = "[A] Oh"
					dialoguePopup.open()
				11:
					# Update dialogue tree state
					dialogue_state = 4
					# Show dialogue popup
					dialoguePopup.npc_name = "Jeff"
					dialoguePopup.dialogue = "Alright, that’s all I know. I’ll meet you at the exit."
					dialoguePopup.answers = "[A] Okay"
					dialoguePopup.open()
				4:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					camera.offset.y = 0
					objective.visible = true
					# Set Fiona's animation to "idle"
					$AnimatedSprite.play("idle")

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		self.talk()

func talk0(answer = ""):
	# Set dialoguePopup npc to Player
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "You"
	
	dialoguePopup.dialogue = "What is going on? Is it a power failure? I should go out and check."
	dialoguePopup.answers = "Press Enter to Continue"
	dialoguePopup.open()


func _on_Timer_timeout():
	self.talk0()
	player.speed = 75
	objective.text = "Objective: Go into any of the rooms to investigate"

extends StaticBody2D

enum QuestStatus { NOT_STARTED, STARTED, COMPLETED }
var quest_status = QuestStatus.NOT_STARTED
var dialogue_state = -2
var keycard_found = false

var dialoguePopup
var player
var camera
var progress
var inventory
var objective
var jeff

func _ready():
	dialoguePopup = get_tree().root.get_node("Root/HUD/DialoguePopup")
	player = get_tree().root.get_node("Root/Player")
	camera = get_tree().root.get_node("Root/Player/Camera2D")
	progress = get_tree().root.get_node("Root/Player/Progress")
	inventory = get_tree().root.get_node("Root/HUD/Inventory")
	objective = get_tree().root.get_node("Root/HUD/Objective")
	jeff = get_tree().root.get_node("Root/Jeff")

func talk(answer = ""):
	# Set dialoguePopup npc to You
	dialoguePopup.npc = self
	camera.offset.y = 100
	objective.visible = false
	
	# Show the current dialogue
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				-2:
					# Update dialogue tree state
					dialogue_state = -1
					# Show dialogue popup
					dialoguePopup.npc_name = "You"
					dialoguePopup.dialogue = "What happened? Why are you crying?"
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
				-1:
					# Update dialogue tree state
					dialogue_state = 0
					# Show dialogue popup
					dialoguePopup.npc_name = "Angela"
					dialoguePopup.dialogue = "Ah! Stay Away! What am I gonna do now. I think the keycard was somewhere here ugh!"
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.npc_name = "You"
					dialoguePopup.dialogue = "Hmm is this the keycard?"
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
				1:
					# Update dialogue tree state
					dialogue_state = 20
					# Show dialogue popup
					dialoguePopup.npc_name = "Angela"
					dialoguePopup.dialogue = "Huh?! You found it!? Oh wait this is the keycard for accessing the control center."
					dialoguePopup.answers = "[A] Oh"
					dialoguePopup.open()
				20:
					# Update dialogue tree state
					dialogue_state = 21
					# Show dialogue popup
					dialoguePopup.npc_name = "Angela"
					dialoguePopup.dialogue = "I lost the one that lets us exit the station :("
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
				21:
					# Update dialogue tree state
					dialogue_state = 22
					# Show dialogue popup
					dialoguePopup.npc_name = "Angela"
					dialoguePopup.dialogue = "Even if we turn off the alarm we can’t exit the station! What am I gonna do?!"
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
				21:
					# Update dialogue tree state
					dialogue_state = 22
					# Show dialogue popup
					dialoguePopup.npc_name = "Angela"
					dialoguePopup.dialogue = "Even if we turn off the alarm we can’t exit the station! What am I gonna do?!"
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
				22:
					# Update dialogue tree state
					dialogue_state = 23
					# Show dialogue popup
					dialoguePopup.npc_name = "You"
					dialoguePopup.dialogue = "Why did you not exit the station with the others?"
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
				23:
					# Update dialogue tree state
					dialogue_state = 24
					# Show dialogue popup
					dialoguePopup.npc_name = "Angela"
					dialoguePopup.dialogue = "The others forced me to stay here to turn off the alarm. BUT I DROPPED BOTH THE KEYCARDS! I’m so stupid *sobs*"
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
				24:
					# Update dialogue tree state
					dialogue_state = 2
					# Show dialogue popup
					dialoguePopup.npc_name = "You"
					dialoguePopup.dialogue = "Don't Worry. I will help you find the keycard."
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.STARTED
					objective.text = "Objective: Find the keycard"
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
					dialoguePopup.npc_name = "Angela"
					dialoguePopup.dialogue = "Did you find it?"
					if keycard_found:
						dialoguePopup.answers = "[A] Yes"
					else:
						dialoguePopup.answers = "[A] No"
					dialoguePopup.open()
				1:
					if keycard_found and answer == "A":
						# Update dialogue tree state
						dialogue_state = 2
						# Show dialogue popup
						dialoguePopup.npc_name = "Angela"
						dialoguePopup.dialogue = "You found it! Great! We can finally leave this station."
						dialoguePopup.answers = "[A] Continue"
						dialoguePopup.open()
					else:
						# Update dialogue tree state
						dialogue_state = 3
						# Show dialogue popup
						dialoguePopup.npc_name = "Angela"
						dialoguePopup.dialogue = "We are all gonna die! I should have never come here."
						dialoguePopup.answers = "[A] Don't worry, I prommise I'll find it"
						dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 10
					quest_status = QuestStatus.COMPLETED
					# Set Fiona's animation to "idle"
					objective.text = "Objective: Scan the keycard and exit"
					dialoguePopup.npc_name = "Angela"
					dialoguePopup.dialogue = "Ugh! I should have stuck to everyone and exited the station."
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
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
					dialoguePopup.npc_name = "Angela"
					dialoguePopup.dialogue = "Let's leave this station ASAP!!"
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
				10:
					# Update dialogue tree state
					dialogue_state = 2
					# Show dialogue popup
					dialoguePopup.npc_name = "Angela"
					dialoguePopup.dialogue = "I’m a fool who just knows how to work with communications. I’m so useless *sobs*"
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 3
					# Show dialogue popup
					dialoguePopup.npc_name = "You"
					dialoguePopup.dialogue = "No! Don’t say that. We all are the hope of humanity. There should be something even you can do."
					dialoguePopup.answers = "[A] Continue"
					dialoguePopup.open()
				3:
					# Update dialogue tree state
					dialogue_state = 12
					# Show dialogue popup
					dialoguePopup.npc_name = "Angela"
					dialoguePopup.dialogue = "Aww you're just being kind. Anyways, the communications are in station B. We should go there so that we can inform WSO."
					dialoguePopup.answers = "[A] Okay"
					dialoguePopup.open()
				12:
					# Update dialogue tree state
					dialogue_state = 4
					
					# Show dialogue popup
					jeff.position = Vector2(1222,265)
					dialoguePopup.npc_name = "Jeff"
					dialoguePopup.dialogue = "Oh, you found the exit keycard? Great! Let's leave this place! The exit is right here."
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

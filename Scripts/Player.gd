extends KinematicBody2D

# Player movement speed
export var speed = 75
var last_direction = Vector2(0, 1)
var dialoguePopup
signal fade_out

func _physics_process(delta):
	# Get player input
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	# Apply movement
	var movement = speed * direction * delta
	move_and_collide(movement)
	animates_player(direction)
	footsteps(movement)

func animates_player(direction: Vector2):
	if direction != Vector2.ZERO:
		# update last_direction
		last_direction = direction
		
		# Choose walk animation based on movement direction
		var animation = get_animation_direction(last_direction) + "_walk"
		
		# Play the walk animation
		$Sprite.play(animation)
	else:
		# Choose idle animation based on last movement direction and play it
		var animation = get_animation_direction(last_direction) + "_idle"
		$Sprite.play(animation)

func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	elif norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	return "down"


func _on_Progress_visibility_changed():
	var visibility = $Progress.visible
	if visibility == false:
		speed = 75
	else:
		speed = 0

func _on_Button_pressed():
	$Progress.start("Scanning Keycard")
	yield(get_tree().create_timer(3), "timeout")
	emit_signal("fade_out")

func footsteps(movement):
	if movement:
		if !$FootSteps.playing:
			$FootSteps.play()
	else:
		if $FootSteps.playing:
			$FootSteps.stop()

func _on_Exit_body_entered(body):
	var inventory = get_tree().root.get_node("Root/HUD/Inventory")
	if body.name == "Player" and inventory.animation == "two_cards":
		$Button.visible = true

func _on_Exit_body_exited(body):
	if body.name == "Player":
		$Button.visible = false

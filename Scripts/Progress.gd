extends Node2D

onready var timer = get_node("Timer")
onready var pb = get_node("ProgressBar")
onready var text = get_node("Label")

func _ready():
	visible = false
	set_process(false)
	pb.value = 3
	timer.wait_time = 0

func _process(delta):
	#print(timer.time_left)
	if pb.value == 3:
		timer.stop()
		visible = false
		set_process(false)
	else:
		pb.value = 3 - timer.time_left

func start(message):
	set_process(true)
	visible = true
	text.text = message
	pb.value = 0
	timer.wait_time = 3
	timer.start()

extends CanvasModulate

export var color1 = Color("4b4b4b")
export var color2 = Color("810000")
export var speed = 3

var time = 0

func _ready():
	pass
	
func _process(delta):
	self.time += delta
	self.color = color2.linear_interpolate(color1, (sin(time*speed) + 1)/2)
	
func _on_Player_fade_out():
	var light = get_tree().root.get_node("Root/Player/Light2D")
	light.enabled = false
	set_modulate(lerp(get_modulate(), Color(0,0,0,1), 0.2))
	get_tree().change_scene("res://Scenes/End.tscn")
	

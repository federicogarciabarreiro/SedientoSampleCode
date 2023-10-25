extends Node2D

@export var index : int = 0

signal object_dropped(index)

var grabbing = false
var drag_start_position = Vector2()

var area : Area2D

@export var can_interact : bool = false

func _ready():
	area = get_node("area")
	
	area.connect("input_event", Callable(self, "_input_event"))
	
	drag_start_position = global_position
	set_process(false)

func _process(_delta):
	if grabbing:
		global_position = get_global_mouse_position()


func _input_event(_viewport, event, _shape_idx):
		if(can_interact):
			if event is InputEventMouseButton:
						if event.button_index == MOUSE_BUTTON_LEFT:
							if event.pressed:
								press(true)
							else:
								emit_signal("object_dropped", index)
								print("signal_send -> " + str(index))
								press(false)
								global_position = drag_start_position

func press(grab):
	grabbing = grab
	set_process(grab)

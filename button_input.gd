extends Node2D

@export var index : int = 0

signal button_input(index)

@onready var audio : AudioStreamPlayer2D

var area : Area2D

func _ready():
	audio = get_node("audio")
	area = get_node("area")
	area.connect("input_event", Callable(self, "_input_event"))

func _input_event(_viewport, event, _shape_idx):
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT:
					if event.pressed:
						emit_signal("button_input", index)
						audio.play()
						print("signal_send -> " + str(index))

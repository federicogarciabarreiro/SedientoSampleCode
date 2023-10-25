extends Node2D

@export var animation_duration: float = 5.0
@export var rotation_range: float = 90.0

@onready var collision_area : Area2D = $area

var elapsedTime: float = 0.0
var initial_rotation: float  = 0.0

func _ready():
	GameManager.countdown = true
	elapsedTime = 0.0
	initial_rotation = rotation_degrees
	
	collision_area.connect("area_entered", Callable(self, "_trigger_enter"))

func _process(delta):
	if GameManager.countdown:
		elapsedTime += delta
		
		var progress = clamp(elapsedTime / animation_duration, 0.0, 1.0)
		var rotationDegrees = lerp(initial_rotation, initial_rotation - rotation_range, progress)
		
		rotation_degrees = rotationDegrees

		if progress >= 1.0:
			elapsedTime = 0.0

func _trigger_enter(area):
		if area == GameManager.player_area && GameManager.player_area != null:
			GameManager.die()

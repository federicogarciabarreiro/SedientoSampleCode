extends Sprite2D

@export var fade_duration = 5.0
var starting_alpha = 0.0
var ending_alpha = 1.0
var timer = 0.0
var is_fading = false

@export var scene_path : String = "" 

@onready var audio : AudioStreamPlayer2D = $audio

func _ready():
	fade_to_black()
	audio.play()

func fade_to_black():
	modulate.a = starting_alpha
	is_fading = true

func _process(delta):
	if is_fading:
		timer += delta
		
		var progress = timer / fade_duration
		modulate.a = lerp(starting_alpha, ending_alpha, progress)

		if timer > fade_duration + 0.5:
			is_fading = false
						
			get_tree().change_scene_to_file(scene_path)
			GameManager.start_values()

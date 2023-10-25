extends Node2D

var images_candle = [
	preload("res://Assets/Sprites/candle_0.png"),
	preload("res://Assets/Sprites/candle_1.png"),
	preload("res://Assets/Sprites/candle_2.png"),
	preload("res://Assets/Sprites/candle_3.png")
]

var images_number = [
	preload("res://Assets/Sprites/number_button_0.png"),
	preload("res://Assets/Sprites/number_button_1.png"),
	preload("res://Assets/Sprites/number_button_2.png"),
	preload("res://Assets/Sprites/number_button_3.png")
]

var buttons := []
var target_numbers = [0, 1, 2, 3]
var button_numbers := []
var clues = []

var quizCompleted := false

@export var enable_feedback_node : Node2D
@export var disable_feedback_node : Node2D

@export var interact_exit : Node2D
@export var interact_info : Node2D

var clues_container : Node2D
var buttons_container : Node2D

@export var audio : AudioStreamPlayer2D

func _ready():
	target_numbers.shuffle()
	
	buttons_container = get_node("play/buttons_container")
	clues_container = get_node("info/clues_container")
	
	audio = get_node("audio")
	
	for n in buttons_container.get_child_count():
		
		var clue = clues_container.get_child(n)
		
		var button = buttons_container.get_child(n)
		
		button.connect("button_input", Callable(self, "_button_input"))
		
		var button_sprite = button.get_node("sprite")
		button_sprite.texture = images_number[0]

		buttons.append(button)
		button_numbers.append(0)
		clues.append(clue)
		
	var current_sprite : int = 0
	for n in target_numbers:
			var clue_sprite = clues[n]
			clue_sprite.texture = images_candle[current_sprite]
			current_sprite += 1

var timer : float = 0.0
func  _process(delta):
	if quizCompleted:
		timer += delta
		
		if timer > 0.5:
			_end_quizz()

func _button_input(index):
		if !quizCompleted:
						button_numbers[index] = (button_numbers[index] + 1) % 4
						
						var button_sprite = buttons[index].get_node("sprite")
						button_sprite.texture = images_number[button_numbers[index]]
						
						var allCorrect = true
						for n in buttons_container.get_child_count():
							if button_numbers[n] != target_numbers[n]:
								allCorrect = false
								break
						
						if allCorrect:
							_on_quiz_completed()

func _on_quiz_completed():
	
	quizCompleted = true
	GameManager.disable_and_hide_node(interact_exit)
	interact_info.can_interact = false
	
	audio.play()
	
func _end_quizz():
	GameManager.player_lock_move = false
	GameManager.player_lock_interact = false
	
	GameManager.quizz_complete()
	
	if is_instance_valid(enable_feedback_node):
		GameManager.enable_and_show_node(enable_feedback_node)
			
	if is_instance_valid(disable_feedback_node):
		GameManager.disable_and_hide_node(disable_feedback_node)
	
	GameManager.disable_and_hide_node(self)

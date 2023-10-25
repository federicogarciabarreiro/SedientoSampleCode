extends Node2D

var clue_images = [
	preload("res://Assets/Sprites/clue_quizz_order_0.png"),
	preload("res://Assets/Sprites/clue_quizz_order_1.png"),
	preload("res://Assets/Sprites/clue_quizz_order_2.png")
]

var buttonNumbers := []
var buttons := []

var quizCompleted := false

var answer_set_0 : Array = [1, 0, 3, 2]
var answer_set_1 : Array = [3, 1, 0, 2]
var answer_set_2 : Array = [3, 1, 2, 0]

var current_answer_set : Array = []
var current_button_index := 0
var try_answer : Array = []

@export var enable_feedback_node : Node2D
@export var disable_feedback_node : Node2D

@export var interact_exit : Node2D
@export var interact_info : Node2D

var sprites_container : Node2D
var buttons_container : Node2D

var audio : AudioStreamPlayer2D

func _ready():
	var randomSet = randi() % 3

	buttons_container = get_node("play/buttons_container")
	sprites_container = get_node("play/sprites_container")
	
	audio = get_node("audio")
	
	for n in buttons_container.get_child_count():
		
		var button = buttons_container.get_child(n)

		buttons.append(button)
		buttonNumbers.append(0)
		
		button.connect("button_input", Callable(self, "_button_input"))
		
		var button_sprite = button.get_node("sprite")
		button_sprite.play("unpress")
		
	match randomSet:
			0:
				current_answer_set = answer_set_0
				var sprite = sprites_container.get_child(0)
				sprite.visible = true
			1:
				current_answer_set = answer_set_1
				var sprite = sprites_container.get_child(1)
				sprite.visible = true
			2:
				current_answer_set = answer_set_2
				var sprite = sprites_container.get_child(2)
				sprite.visible = true

var timer : float = 0.0
func  _process(delta):
	if quizCompleted:
		timer += delta
		
		if timer > 0.5:
			_end_quizz()

func _button_input(index):
		if !quizCompleted:
						var button_sprite = buttons[index].get_node("sprite")
						button_sprite.play("press")
						current_button_index += 1
						try_answer.append(index)
						if current_button_index == 4:
							_check_on_quiz_completed()

func _check_on_quiz_completed():
	var correct_answer: int = 0
	
	for n in buttons_container.get_child_count():
		if try_answer[n] == current_answer_set[n]:
			correct_answer += 1
	
	if correct_answer == 4:
		quizCompleted = true
		GameManager.disable_and_hide_node(interact_exit)
		interact_info.can_interact = false
		
		audio.play()
	else:
		_reset_quiz()

func _end_quizz():
	GameManager.player_lock_move = false
	GameManager.player_lock_interact = false
	
	GameManager.quizz_complete()
	
	if is_instance_valid(enable_feedback_node):
		GameManager.enable_and_show_node(enable_feedback_node)
			
	if is_instance_valid(disable_feedback_node):
		GameManager.disable_and_hide_node(disable_feedback_node)
	
	GameManager.disable_and_hide_node(self)

func _reset_quiz():
	
	try_answer.clear()
	
	for n in buttons_container.get_child_count():
		var button_sprite = buttons[n].get_node("sprite")
		button_sprite.play("unpress")
		
	current_button_index = 0

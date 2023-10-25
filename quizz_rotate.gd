extends Node2D

var buttons := []
var button_rotations := []
var target_rotations = [0, 90, 180, 270]

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
	target_rotations.shuffle()
	
	buttons_container = get_node("play/buttons_container")
	clues_container = get_node("info/clues_container")
	
	audio = get_node("audio")
		
	for n in buttons_container.get_child_count():
		
		var clue = clues_container.get_child(n)	
		var button = buttons_container.get_child(n)
		
		buttons.append(button)
		
		button.connect("button_input", Callable(self, "_button_input"))
		
		clues.append(clue)
		
		button_rotations.append(0)

	for clue_index in range(clues.size()):
		var target_rotation = target_rotations[clue_index]
		clues[clue_index].rotation_degrees = target_rotation

var timer : float = 0.0
func  _process(delta):
	if quizCompleted:
		timer += delta
		
		if timer > 0.5:
			_end_quizz()

func _button_input(index):
		if !quizCompleted:
			button_rotations[index] = (button_rotations[index] + 90) % 360
			
			buttons[index].rotation_degrees = button_rotations[index]
			
			print(str(button_rotations) + "" + str(target_rotations))
			
			var complete : bool = true
			for n in button_rotations.size():
				if button_rotations[n] != target_rotations[n]:
						complete = false
			
			if complete:
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

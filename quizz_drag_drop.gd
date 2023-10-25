extends Node2D

var holders = []
var draggables = []
var correct_count = 0
var restarts_left = 0

@export var tolerance = 100

var n_correct_count : int

@export var enable_feedback_node : Node2D
@export var disable_feedback_node : Node2D

@export var enable_next_drag : bool = false
@export var enable_next_holder : bool = false

@export var interact_exit : Node2D

var dragables_container : Node2D
var holders_container : Node2D

var audio : AudioStreamPlayer2D
var audio_container : AudioStreamPlayer2D

var quizCompleted := false

func _ready():
	
	dragables_container = get_node("play/dragables_container")
	holders_container = get_node("play/holders_container")
	audio = get_node("audio")
	audio_container = holders_container.get_node("audio")
	
	for n in dragables_container.get_child_count():
		
		var holder = holders_container.get_child(n)
		var draggable = dragables_container.get_child(n)
		
		draggable.connect("object_dropped", Callable(self, "_object_dropped"))
		
		holders.append(holder)
		draggables.append(draggable)
	
	n_correct_count = dragables_container.get_child_count()
	
var timer : float = 0.0
func  _process(delta):
	if quizCompleted:
		timer += delta
		
		if timer > 0.5:
			_end_quizz()
	
func _object_dropped(index):
	if quizCompleted:
		return

	if !holders_container.is_visible_in_tree():
		return
	
	var draggable = draggables[index]
	var holder = holders[index]

	var draggable_area = draggable.get_node("area")
	var holder_area = holder.get_node("area")

	

	if draggable_area != null && holder_area != null:
		if draggable_area.get_overlapping_areas().find(holder_area) != -1:
			draggable.global_position = holder.global_position
			correct_count += 1
			
			audio_container.play()
			print(correct_count)
			
			if correct_count < dragables_container.get_child_count():
			
				if enable_next_drag:
					GameManager.enable_and_show_node(draggables[correct_count])
						
				if enable_next_holder:
					GameManager.enable_and_show_node(holders[correct_count])
					
			if holder.has_node("sprite"):
				holder.get_node("sprite").visible = true
				
			if correct_count == n_correct_count:
				quizCompleted = true
				if interact_exit:
					GameManager.disable_and_hide_node(interact_exit)
			
				audio.play()
							
						
			GameManager.disable_and_hide_node(draggable)

func _end_quizz():
	GameManager.player_lock_move = false
	GameManager.player_lock_interact = false
	
	GameManager.quizz_complete()
	
	if is_instance_valid(enable_feedback_node):
		GameManager.enable_and_show_node(enable_feedback_node)
			
	if is_instance_valid(disable_feedback_node):
		GameManager.disable_and_hide_node(disable_feedback_node)
	
	GameManager.disable_and_hide_node(self)

extends Node2D

@export var enable_feedback_node : Node2D
@export var aux_enable_feedback_node : Node2D
@export var disable_feedback_node : Node2D
@export var aux_disable_feedback_node : Node2D

var area : Area2D
var audio: AudioStreamPlayer2D
var player_reference : Node2D

@export var interact_distance : float = 3.0
@export var can_interact : bool = true

@export var disable_interact_on_use : bool = false
@export var die_on_use : bool = false

@export var disable_player_on_use : bool = false
@export var enable_player_on_use : bool = false

@export var ignore_global_values : bool = false

@export var fixed_position_to_interact : Node2D

@export var anim : AnimationPlayer
@export var animation_name : String = ""

var on_die : bool = false

func _ready():
	
	player_reference = GameManager.player
	
	audio = get_node("audio")
	area = get_node("area")
	
	area.connect("input_event", Callable(self, "_input_event"))
	
	if anim:
		anim.play(animation_name)

var timer : float = 0.0
func  _process(delta):
	if on_die:
		timer += delta
		
		if timer > 0.1:
			GameManager.disable_and_hide_node(self)

func _input_event(_viewport, event, _shape_idx):
	if !ignore_global_values:
		if !GameManager.player_lock_interact:
			if(can_interact):
				if 	player_reference != null:
					var distance = global_position.distance_to(player_reference.global_position)
				
					if distance < interact_distance:
						button(event)
					else:
						button_over_distance(event)
				else:
					button(event)
	else:
		button(event)

func button(event):
	if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT:
					if event.pressed:
						press()
						

func  button_over_distance(event):
	if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT:
					if event.pressed:
						if fixed_position_to_interact:
							GameManager.player.move_to_position(fixed_position_to_interact.global_position)

func press():
	audio.play()
	
	if is_instance_valid(enable_feedback_node):
		GameManager.enable_and_show_node(enable_feedback_node)
	
	if is_instance_valid(aux_enable_feedback_node):
		GameManager.enable_and_show_node(aux_enable_feedback_node)
			
	if is_instance_valid(disable_feedback_node):
		GameManager.disable_and_hide_node(disable_feedback_node)
		
	if is_instance_valid(aux_disable_feedback_node):
		GameManager.disable_and_hide_node(aux_disable_feedback_node)
		
	if disable_interact_on_use:
		can_interact = false
	
	if disable_player_on_use:
		set_player_state(false)

	if enable_player_on_use:
		set_player_state(true)

	if die_on_use:
		on_die = true

func set_player_state(state):
	GameManager.player_lock_interact = !state
	GameManager.player_lock_move = !state

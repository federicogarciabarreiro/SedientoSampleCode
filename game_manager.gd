extends Node2D

@export var _n_win_check : int = -1
var n_current_win_check : int = 0

@export var win_feedback_node = Node2D
@export var lose_feedback_node = Node2D
@export var blood_feedback_node = Node2D
@export var door_block_feedback_node = Node2D

@export var player_die: bool = false

@export var player_lock_interact: bool = false 
@export var player_lock_move : bool = false

@export var countdown: bool = true

@export var player : Node2D
@export var player_area : Node2D

func _ready():
	start_values()

func start_values():
		player_die = false
		
		player_lock_interact = false
		player_lock_move = false
		
		countdown = true
		
		n_current_win_check = 0

func quizz_complete():
	n_current_win_check += 1
	
	if _n_win_check == n_current_win_check:
		
		game_end()
		
		enable_and_show_node(win_feedback_node)
		
		disable_and_hide_node(door_block_feedback_node)

func die():
		print("die")
	
		game_end()
		
		enable_and_show_node(blood_feedback_node)
		
		enable_and_show_node(lose_feedback_node)

func game_end():
	player_die = true
	
	player_lock_interact = true
	player_lock_move = true
	
	countdown = false

func disable_and_hide_node(node:Node) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.visible = false
	node.hide()

func enable_and_show_node(node:Node) -> void:
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node.visible = true
	node.show()

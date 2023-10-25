extends Node2D

@export var n_win_check : int = 5
@export var _win_feedback_node : Node2D
@export var _lose_feedback_node : Node2D
@export var _door_block_feedback_node : Node2D
@export var _blood_feedback_node : Node2D

func _ready():
	
	GameManager._n_win_check = n_win_check
	GameManager.win_feedback_node = _win_feedback_node
	GameManager.lose_feedback_node = _lose_feedback_node
	GameManager.blood_feedback_node = _blood_feedback_node
	GameManager.door_block_feedback_node = _door_block_feedback_node
	GameManager.start_values()

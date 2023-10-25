extends Node2D

var timer : Timer = Timer.new()

@export var enable_feedback_node : Node2D
@export var disable_feedback_node : Node2D


@export var wait_time : float = 3.0

var audioplayer : AudioStreamPlayer2D

@export var anim : AnimationPlayer
@export var animation_name : String = ""

func _ready():
	audioplayer = get_node("audioplayer")
		
	timer.wait_time = wait_time
	timer.autostart = true
	timer.one_shot = true
	
	timer.connect("timeout", Callable(self, "_timeout"))
	add_child(timer)
	
	if anim:
		anim.play(animation_name)
	
func _timeout():
	
	if audioplayer:
		audioplayer.play()
	
	if is_instance_valid(enable_feedback_node):
		GameManager.enable_and_show_node(enable_feedback_node)
			
	if is_instance_valid(disable_feedback_node):
		GameManager.disable_and_hide_node(disable_feedback_node)
	
	

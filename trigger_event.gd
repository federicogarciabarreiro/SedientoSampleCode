extends Node2D

@export var collision_target : Node2D
var collision_area_target : Area2D = null

var _area : Area2D
var sprite : AnimatedSprite2D
var audioplayer : AudioStreamPlayer2D

@export var invert : bool = false

func _ready():
	
	if invert:
		transform.origin.x *= -1
	
	_area = get_node("area")
	sprite = get_node("sprite")
	audioplayer = get_node("audioplayer")
	
	collision_area_target = collision_target.get_node("area")
	
	_area.connect("area_entered", Callable(self, "_area_enter"))
	
func _area_enter(area):
	if area == collision_area_target && collision_area_target != null:
		audioplayer.play()
		sprite.play("start")
		collision_area_target = null

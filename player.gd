extends CharacterBody2D

var is_moving = false
var is_waiting_for_click = true
var target_position = Vector2()
@export var speed : float = 50
@export var stopping_distance : float = 5.0
@onready var navigation_agent : NavigationAgent2D = $navigation_agent

var anim : AnimationPlayer
var sprite : Sprite2D

var audio : AudioStreamPlayer2D

var regions := []

func _ready():
	GameManager.player = self
	GameManager.player_area = self.get_node("area")
	
	var regions_container = get_node("/root/world/regions_container")
	
	anim = get_node("anim")
	sprite = get_node("sprite")
	
	audio = get_node("audio")
	
	for child in regions_container.get_children():
		regions.append(child)

func is_point_in_polygon(point, polygon) -> bool:
	var is_inside = false
	var j = polygon.size() - 1

	for i in range(polygon.size()):
		var vertex_i = polygon[i]
		var vertex_j = polygon[j]

		if (vertex_i.y > point.y) != (vertex_j.y > point.y) && (point.x <= (vertex_j.x - vertex_i.x) * (point.y - vertex_i.y) / (vertex_j.y - vertex_i.y) + vertex_i.x):
			is_inside = !is_inside

		j = i

	return is_inside

func is_point_in_any_region(point, _regions) -> bool:
	for region in _regions:
		if is_point_in_polygon(point, region.navigation_polygon.vertices):
			return true
	return false

func _physics_process(_delta):
	if is_moving:
		if GameManager.player_lock_move:
			is_moving = false
			anim.play("idle")
			return
		
		var direction = navigation_agent.get_next_path_position() - global_position
		direction = direction.normalized()

		velocity = direction * speed

		if global_position.distance_to(target_position) > stopping_distance:
			move_and_slide()

			if direction.x > 0:
				sprite.scale.x = abs(sprite.scale.x)
			elif direction.x < 0:
				sprite.scale.x = -abs(sprite.scale.x)

		else:
			is_moving = false
			anim.play("idle")

func _input(event):
	if !GameManager.player_lock_move:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					
					var mouse_position = get_global_mouse_position()

					if is_point_in_any_region(mouse_position, regions):
						for region in regions:
							if is_point_in_polygon(mouse_position, region.navigation_polygon.vertices):
								
								move_to_position(mouse_position)
								break

func move_to_position(new_position):
	var direction = new_position - global_position
	var distance_to_target = direction.length()

	if distance_to_target <= stopping_distance:
		is_moving = false
		anim.play("idle")
		return
		
	direction = direction.normalized()
	
	navigation_agent.target_position = new_position
	target_position = new_position
	is_moving = true
	anim.play("walk")
	is_waiting_for_click = false


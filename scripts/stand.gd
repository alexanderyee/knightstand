extends CharacterBody2D

@export var speed := 150.0
@export var max_range := 50	
@export var max_tether_range := 55
@export var tether_tension := 5.0
@export var friction := 7.0
@onready var knight: Knight = $"../Knight"

func _physics_process(delta: float) -> void:
	var raw_input := Input.get_vector("move_stand_left", "move_stand_right", "move_stand_up", "move_stand_down")
	
	if raw_input:
		velocity = raw_input * speed
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction * delta)
	
	# stand has a limited range, so it can only be a specific distance away from the knight
	var distance_to_knight := position.distance_to(knight.position) 
	if distance_to_knight >= max_tether_range:
		# find the point that's max distance between knight and stand
		var vector_towards_knight := knight.position - position
		var vector_towards_max_range := vector_towards_knight.limit_length(distance_to_knight - max_range)
		position = lerp(position, position + vector_towards_max_range, tether_tension * delta)
	
	move_and_slide()

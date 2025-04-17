extends CharacterBody2D

const GRAVITY_ORB_SCENE = preload("res://scenes/gravity_orb.tscn")
const GRAVITY_ZONE_SCENE = preload("res://scenes/gravity_zone.tscn")


@export var speed := 150.0
@export var max_range := 50
@export var max_tether_range := 55
@export var tether_tension := 5.0
@export var friction := 7.0
@export var grav_zone_width := 20.0



@onready var knight: Knight = $"../Knight"

var grav_zone_ghost: Line2D

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
	
	if Input.is_action_pressed("stand_ability_1"):
		# instantiate line if haven't already 
		if not grav_zone_ghost:
			grav_zone_ghost = Line2D.new()
			grav_zone_ghost.width = 2
			grav_zone_ghost.default_color = Color.from_rgba8(226, 169, 178, 100)
			add_sibling(grav_zone_ghost)
			grav_zone_ghost.add_point(get_global_mouse_position())
		# remove the last point and add a new one at mouse position
		else:
			grav_zone_ghost.remove_point(grav_zone_ghost.get_point_count() - 1)
		grav_zone_ghost.add_point(get_global_mouse_position())
	if Input.is_action_just_released("stand_ability_1"):
		# create grav zone between points
		# TODO move this to constructor of gravity zone
		var gravity_zone := GRAVITY_ZONE_SCENE.instantiate()
		var grav_zone_collision_shape = CollisionShape2D.new()
		var grav_zone_rect_shape = RectangleShape2D.new()
		grav_zone_rect_shape.size = Vector2(get_line2d_length(grav_zone_ghost), grav_zone_width)
		grav_zone_collision_shape.shape = grav_zone_rect_shape
		gravity_zone.add_child(grav_zone_collision_shape)
		gravity_zone.rotate(grav_zone_ghost.points[0].angle_to_point(grav_zone_ghost.points[1]))
		gravity_zone.global_position = (grav_zone_ghost.points[0] + grav_zone_ghost.points[1]) / 2.0
		gravity_zone.gravity_direction =  (grav_zone_ghost.points[1] -  grav_zone_ghost.points[0]).normalized()
		gravity_zone.gravity = 1500.0
		add_sibling(gravity_zone)
		grav_zone_ghost.queue_free()
		print()
		
	move_and_slide()

# should only be for two points in this function, but decided to do it for any
# number of points anyway for utility (should be global then)
func get_line2d_length(line: Line2D) -> float:
	var length := 0.0
	var prev_point
	for point in line.points:
		if prev_point:
			length += (point - prev_point).length()
		prev_point = point
	return length

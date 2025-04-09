extends Camera2D

@export var horizontal_lookahead = 20
@export var lookahead_speed = 3.0
# TODO would this be better as a global/autoload?
@onready var level_layout = get_node("../../LevelLayout")
 
var face_direction := 1.0

func _ready() -> void:
	var camera_limits: Array = level_layout.get_level_bounds()
	limit_right = camera_limits[0]
	limit_left = camera_limits[1]
	limit_bottom = camera_limits[2]
	limit_top = camera_limits[3]
	pass # Replace with function body.


func _process(delta: float) -> void:
	var knight = get_owner()

	# make knight look ahead of direction he's facing
	var knight_face_direction = signf(knight.velocity.x)
	if knight_face_direction != 0.0:
		face_direction = knight_face_direction
	var horizontal_offset = face_direction * horizontal_lookahead
	
	var lookahead_offset = Vector2(horizontal_offset, 0)
	offset = lerp(offset, lookahead_offset, lookahead_speed * delta)
	pass

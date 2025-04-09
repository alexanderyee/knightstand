extends Camera2D

@export var horizontal_lookahead = 10.0
@export var lookahead_speed = 2.5

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	var knight = get_owner()

	# make knight look ahead of direction he's facing
	var knight_face_direction = signf(knight.velocity.x)
	var horizontal_offset = knight_face_direction * horizontal_lookahead
	
	var lookahead_offset = Vector2(horizontal_offset, 0)
	offset = lerp(offset, lookahead_offset, lookahead_speed * delta)
	pass

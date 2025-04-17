extends Area2D


func _ready() -> void:
	collision_layer = 0
	collision_mask = 2 # player layer

func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body: Node2D) -> void:
	# we can only apply gravity to the knight for now
	if body is Knight:
		body.is_in_grav = true

func _on_body_exited(body: Node2D) -> void:
	if body is Knight:
		body.is_in_grav = false
		body.momentum_timer = 0.3  # seconds
		body.momentum_locked = true

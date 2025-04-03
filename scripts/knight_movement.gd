extends Node2D

@onready var animation_tree: AnimationTree = $"../AnimationTree"
@onready var knight: Knight = get_owner()

var last_facing_direction := 1.0

func _physics_process(delta: float) -> void:
	
	var idle = !knight.velocity.x
	
	if !idle:
		last_facing_direction = knight.velocity.x
		
	animation_tree.set("parameters/idle/BlendSpace1D/blend_position", last_facing_direction)
	animation_tree.set("parameters/walk/BlendSpace1D/blend_position", last_facing_direction)

	pass

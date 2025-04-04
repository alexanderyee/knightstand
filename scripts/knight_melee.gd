extends Node2D

enum KnightAttackState {ATTACK1, ATTACK2, ATTACK3, NONE}

@onready var animation_tree: AnimationTree = $"../AnimationTree"
@onready var knight: Knight = get_owner()

var last_facing_direction := 1.0

func _physics_process(delta: float) -> void:
	
	#var is_idle = !knight.velocity
	#var is_attacking = knight.attack_state != KnightAttackState.NONE
	#
	#if !is_idle:
		#last_facing_direction = knight.velocity.x
		#
	#if is_attacking:
		#animation_tree.set("parameters/" +
		 #knight.ATTACK_ANIM_NAMES[knight.attack_state] +
		 #"/BlendSpace1D/blend_position", last_facing_direction)

	pass

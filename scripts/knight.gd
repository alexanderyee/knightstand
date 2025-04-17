class_name Knight
extends CharacterBody2D

@export var speed = 100.0
@export var jump_velocity = -250.0
@export var friction = 1000.0
const ATTACK_ANIM_NAMES = ["attack1", "attack2", "attack3"]
const MAX_MOMENTUM_TIME = 6.0

@onready var anim_tree: AnimationTree = $AnimationTree
var anim_tree_state_machine
enum AttackState {ATTACK1, ATTACK2, ATTACK3, NONE = -1}
var attack_state: AttackState
var in_action = false
var last_facing_direction = 1.0
var is_in_grav = false
var momentum_timer = 0.0
var momentum_locked = false

func _ready() -> void:
	anim_tree_state_machine = anim_tree.get("parameters/playback")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() or is_in_grav:
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("knight_jump") and is_on_floor():
		velocity.y = jump_velocity
	var direction := Input.get_axis("move_knight_left", "move_knight_right")
	if not is_in_grav:
		if not momentum_locked:
			if direction:
				velocity.x = direction * speed
			else:
				velocity.x = move_toward(velocity.x, 0, friction * delta)
		else:
			var blend_factor = clamp(momentum_timer / MAX_MOMENTUM_TIME, 0, 1)
			var input_velocity = direction * speed
			velocity.x = lerp(velocity.x, input_velocity, blend_factor)
			var vel = lerp(velocity.x, input_velocity, blend_factor)
			momentum_timer -= delta
			if momentum_timer <= 0.0:
				momentum_locked = false
				
			
	# Handle attack, walk, idle anims
	# Blendtree params are set by KnightMovement and KnightMelee components
	if !in_action:
		if attack_state == AttackState.NONE:
			if velocity:
				anim_tree_state_machine.travel("walk")
			else:
				anim_tree_state_machine.travel("idle")
			
		if direction:
			last_facing_direction = direction
		elif velocity.x:
			last_facing_direction = velocity.x
							
		anim_tree.set("parameters/idle/BlendSpace1D/blend_position", last_facing_direction)
		anim_tree.set("parameters/walk/BlendSpace1D/blend_position", last_facing_direction)
		for atk in ATTACK_ANIM_NAMES:
			anim_tree.set("parameters/" + atk + "/BlendSpace1D/blend_position", 
			last_facing_direction)
		if Input.is_action_just_pressed("knight_attack1"):
			attack_state = AttackState.ATTACK1
			anim_tree_state_machine.travel("attack1")
			in_action = true
		elif Input.is_action_just_pressed("knight_attack2"):
			attack_state = AttackState.ATTACK2
			anim_tree_state_machine.travel("attack2")
			in_action = true
		elif Input.is_action_just_pressed("knight_attack3"):
			attack_state = AttackState.ATTACK3
			anim_tree_state_machine.travel("attack3")
			in_action = true
		else:
			attack_state = AttackState.NONE
		
	
	move_and_slide()


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	for action_anim_name in ATTACK_ANIM_NAMES:
		if anim_name.contains(action_anim_name):
			in_action = false
			attack_state = AttackState.NONE

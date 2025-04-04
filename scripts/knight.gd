class_name Knight
extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
const ATTACK_ANIM_NAMES = ["attack1", "attack2", "attack3"]

@onready var anim_tree: AnimationTree = $AnimationTree
var anim_tree_state_machine
enum AttackState {ATTACK1, ATTACK2, ATTACK3, NONE = -1}
var attack_state: AttackState
var in_action = false
var last_facing_direction = 1.0

func _ready() -> void:
	anim_tree_state_machine = anim_tree.get("parameters/playback")

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("knight_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_knight_left", "move_knight_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle attack, walk, idle anims
	# Blendtree params are set by KnightMovement and KnightMelee components
	if !in_action:
		if attack_state == AttackState.NONE:
			if velocity:
				anim_tree_state_machine.travel("walk")
			else:
				anim_tree_state_machine.travel("idle")
			
		if velocity.x:
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

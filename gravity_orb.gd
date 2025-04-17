extends Area2D

@export var base_strength := .005

var bodies_in_aoe := []

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2 # player layer

func _process(delta: float) -> void:
	for body_dict in bodies_in_aoe:
		# for now we just multiply the entry vector and speed
		#body_dict["body"].velocity += body_dict["entry_vector"] * body_dict["entry_speed"] * base_strength
		pass
		
func _on_body_entered(body: Node2D) -> void:
	# we can only apply gravity to the knight for now
	if body is Knight:
		# calc normal vector from player to center of aoe
		var vector_towards_orb : Vector2 = position - body.position
		var dir_of_gravity := vector_towards_orb.normalized()
		bodies_in_aoe.append({
			"body": body,
			"entry_vector": vector_towards_orb.normalized(),
			"entry_speed": body.velocity.length()}
		)
		body.is_in_grav = true
		

func _on_body_exited(body: Node2D) -> void:
	if body is Knight:
		body.is_in_grav = false
		var indices_to_delete := []
		for i in range(bodies_in_aoe.size()):
			if bodies_in_aoe[i]["body"] == body:
				indices_to_delete.push_front(i)
				
		for i in indices_to_delete:
			bodies_in_aoe.remove_at(i)
 

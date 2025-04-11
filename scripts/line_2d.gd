extends Line2D

@onready var knight: Knight = $"../Knight"
@onready var stand: CharacterBody2D = $"../Stand"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	points = [knight.position, stand.position]
	pass

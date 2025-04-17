class_name LevelLayout
extends Node2D

var tilemap_layers : Array[Node]
var x_upper_bound := -10000000
var x_lower_bound := 10000000
var y_upper_bound := -10000000
var y_lower_bound := 10000000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap_layers = get_children()
	for tilemap_layer: TileMapLayer in tilemap_layers:
		var tilemap_layer_bounds = tilemap_layer.get_used_rect()
		var tile_size_pixels = tilemap_layer.get_rendering_quadrant_size()
		var tilemap_layer_bounds_pixels: Rect2i = Rect2i(tilemap_layer_bounds.position * tile_size_pixels, tilemap_layer_bounds.size * tile_size_pixels)
		if tilemap_layer_bounds_pixels.position.x < x_lower_bound:
			x_lower_bound = tilemap_layer_bounds_pixels.position.x
		if tilemap_layer_bounds_pixels.position.y < y_lower_bound:
			y_lower_bound = tilemap_layer_bounds_pixels.position.y
		if tilemap_layer_bounds_pixels.end.x > x_upper_bound:
			x_upper_bound = tilemap_layer_bounds_pixels.end.x
		if tilemap_layer_bounds_pixels.end.y > y_upper_bound:
			y_upper_bound = tilemap_layer_bounds_pixels.end.y
# returns the bounds of the level, used for limiting the camera
func get_level_bounds() -> Array:
	return [x_upper_bound, x_lower_bound, y_upper_bound, y_lower_bound]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

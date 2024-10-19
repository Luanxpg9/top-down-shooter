extends TileMapLayer

var map_size = Vector2i(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_size = Vector2i(randi_range(15, 20), randi_range(15, 20))
	create_map()

func create_map() -> void:
	create_world_border()
	wave_function_collapse()
	# fill_map()

# Create world border
func create_world_border() -> void:
	set_corners()
	set_outter_walls()
	pass
# Filling map using the wave function colapse (Oh my Gotto Algorithms)

# Setting corners of the map
func set_corners() -> void:
	var iterable_size = Vector2i(map_size.x - 1, map_size.y - 1)
	# Upper Left
	set_cell(Vector2i(0, 0), 0, Vector2i(0, 0))
	# Lower Left
	set_cell(Vector2i(0, iterable_size.y), 0, Vector2i(1, 0))
	# Upper Right
	set_cell(Vector2i(iterable_size.x, 0), 0, Vector2i(3, 0))
	# Lower Right
	set_cell(Vector2i(iterable_size.x, iterable_size.y), 0, Vector2i(2, 0))

func set_outter_walls() -> void:
	# Left & Right wall
	for y in range(map_size.y-2):
		set_cell(Vector2i(0, y+1), 0, Vector2i(2, 1))
		set_cell(Vector2i(map_size.x-1, y+1), 0, Vector2i(3, 1))
	# Up & down wall
	for x in range(map_size.x-2):
		set_cell(Vector2i(x+1, 0), 0, Vector2i(0, 1))
		set_cell(Vector2i(x+1, map_size.y-1), 0, Vector2i(1, 1))

func wave_function_collapse() -> void:
	var inner_box_dimensions = Vector2i(map_size.x-1, map_size.y)
	var coord_x = 0
	var coord_y = 0
	var empty_space = Vector2i(1,3)
	
	for x in range(inner_box_dimensions.x-2):
		for y in range(inner_box_dimensions.y-2):
			coord_x = randi_range(0, 3)
			coord_y = randi_range(2, 5)
			if coord_y > 2:
				set_cell(Vector2i(x+1, y+1), 0, empty_space)
			else:
				set_cell(Vector2i(x+1, y+1), 0, Vector2i(coord_x, coord_y))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	wave_function_collapse()

extends Node2D

const ALIVE_ID = 0

var born = 3
var survive_min = 2
var die_min = 4

onready var selecter = $Selecter

onready var buffer1 = $Buffer1
onready var buffer2 = $Buffer2
onready var active_buffer = buffer1
onready var inactive_buffer = buffer2

onready var timer = $WaitBetweenGenTimer

var simulating = false

var mouse_in_ui = false


func _physics_process(delta):
	if not simulating and not mouse_in_ui:
		selecter.clear()
		var mouse_pos = selecter.world_to_map(get_global_mouse_position())
		selecter.set_cellv(mouse_pos, 1)
	
		if Input.is_action_pressed("place_cell"):
			active_buffer.set_cellv(mouse_pos, 0)
		
		if Input.is_action_pressed("remove_cell"):
			active_buffer.set_cellv(mouse_pos, -1)


func _compute_next_generation():
	var dead_cells = []
	
	# Clear inactive buffer
	inactive_buffer.clear()
	
	for cell in active_buffer.get_used_cells():
		# Get dead cells near cells that are alive
		dead_cells += get_surrounding_dead_cells(cell)
		
		# Simulate alive cells
		var neighbor_info = get_surrounding_cells_info(cell)
		if neighbor_info["alive"] < survive_min || neighbor_info["alive"] >= die_min:
			pass # Cell died, RIP
		else:
			# Cell stay alive, yay!
			inactive_buffer.set_cellv(cell, 0)

	
	# Simulate dead cells
	for cell in dead_cells:
		var neighbor_info = get_surrounding_cells_info(cell)
		if neighbor_info["alive"] == born:
			# A new cell is born
			inactive_buffer.set_cellv(cell, 0)
	
	switch_buffer()


func get_surrounding_dead_cells(cell_pos):
	var dead_cells = []
	
	var around = get_surrounding_cells_pos(cell_pos)

	for cell in around:
		if active_buffer.get_cellv(cell) == TileMap.INVALID_CELL:
			dead_cells.append(cell)

	return dead_cells


func get_surrounding_cells_info(cell_pos):
	var info = {
		"dead": 0,
		"alive": 0
	}
	
	var around = get_surrounding_cells_pos(cell_pos)

	for cell in around:
		match active_buffer.get_cellv(cell):
			TileMap.INVALID_CELL:
				info["dead"] += 1
			ALIVE_ID:
				info["alive"] += 1
	
	return info

func get_surrounding_cells_pos(cell_pos):
	return [
		Vector2(cell_pos.x, cell_pos.y - 1), # Up
		Vector2(cell_pos.x, cell_pos.y + 1), # Down
		Vector2(cell_pos.x - 1, cell_pos.y), # Left
		Vector2(cell_pos.x + 1, cell_pos.y), # Right
		Vector2(cell_pos.x - 1, cell_pos.y - 1), # Up Left
		Vector2(cell_pos.x + 1, cell_pos.y - 1), # Up right
		Vector2(cell_pos.x - 1, cell_pos.y + 1), # Down left
		Vector2(cell_pos.x + 1, cell_pos.y + 1)  # Down right
	]


func switch_buffer():
	var active = active_buffer
	active_buffer = inactive_buffer
	inactive_buffer = active
	
	# Show the newly active buffer
	active_buffer.visible = true
	inactive_buffer.visible = false


func start_simulation():
	selecter.clear()
	simulating = true
	timer.start()


func stop_simulation():
	simulating = false
	timer.stop()


func reset_simulation():
	stop_simulation()
	
	active_buffer = buffer1
	inactive_buffer = buffer2
	active_buffer.clear()
	inactive_buffer.clear()


func update_born(value):
	born = value


func update_survive(value):
	survive_min = value


func update_die(value):
	die_min = value


func update_simulation_speed(value):
	timer.wait_time = value


func _on_UI_mouse_in_ui():
	mouse_in_ui = true


func _on_UI_mouse_left_ui():
	mouse_in_ui = false

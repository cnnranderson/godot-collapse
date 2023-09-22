@tool
extends EditorPlugin

var command_palette := get_editor_interface().get_command_palette()
var commands := [
	["Spread horizontal", "extra/spread_horizontal", spread_horizontal],
	["Spread vertical", "extra/spread_vertical", spread_vertical],
	["Align", "extra/align", align_nodes],
	["Reset transform", "extra/reset_transform", reset_transform]
]

func _enter_tree():
	# Register all custom commands
	for command in commands:
		command_palette.add_command(command[0], command[1], command[2])

func _exit_tree():
	# Unregister all custom commands
	for command in commands:
		command_palette.remove_command(command[1])

func align_nodes(spread: Vector2 = Vector2(0, 0)):
	var editor := get_editor_interface()
	
	if editor.get_selection() != null:
		var prev_node: Node2D = null
		for node in editor.get_selection().get_transformable_selected_nodes():
			# Pick the first node to use as a point of reference
			if prev_node == null:
				prev_node = node
				continue
			
			# Align all subsequent nodes to the previous node, horizontally
			if node is Node2D:
				node.position.x = (prev_node.position.x + spread.x) if spread.x != 0 else prev_node.position.x
				node.position.y = (prev_node.position.y + spread.y) if spread.y != 0 else prev_node.position.y
				prev_node = node

func spread_horizontal():
	align_nodes(Vector2(50, 0))

func spread_vertical():
	align_nodes(Vector2(0, 50))

func reset_transform():
	var editor := get_editor_interface()
	
	if editor.get_selection() != null:
		var prev_node: Node2D = null
		for node in editor.get_selection().get_transformable_selected_nodes():
			node.position = Vector2(0, 0)

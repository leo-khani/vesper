extends Node

# Nodes
var player_node: Node = null: set = _on_node_changed


# Particles


# PackedScenes Refs

signal node_changed(new_node: Node)


# This fires a signal every time a node have been changed
func _on_node_changed(new_node: Node) -> void:
	player_node = new_node
	node_changed.emit(player_node)

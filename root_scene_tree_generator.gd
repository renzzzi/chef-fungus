extends Node

func _ready() -> void:
	print_tree_ascii(self)


func print_tree_ascii(node: Node, prefix: String = "", is_last: bool = true) -> void:
	var connector = "└── " if is_last else "├── "

	if node != self:
		print(prefix + connector + node.name)

	var children = node.get_children()

	for i in children.size():
		var child = children[i]
		var child_prefix = prefix

		if node != self:
			child_prefix += "    " if is_last else "│   "

		print_tree_ascii(child, child_prefix, i == children.size() - 1)

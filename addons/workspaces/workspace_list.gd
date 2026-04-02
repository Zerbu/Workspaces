@tool
extends ItemList

func _get_drag_data(at_position: Vector2) -> Variant:
	var item = get_item_at_position(at_position)
	if item == -1:
		return null
	var label = Label.new()
	label.text = get_item_text(item)
	set_drag_preview(label)
	return Workspaces.settings.workspaces[item]

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is Workspace:
		return true
	return false

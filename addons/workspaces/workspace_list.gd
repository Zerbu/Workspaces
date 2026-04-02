@tool
extends ItemList

func _get_drag_data(at_position: Vector2) -> Variant:
	var index = get_item_at_position(at_position)
	if index == -1:
		return null
	var label = Label.new()
	label.text = get_item_text(index)
	set_drag_preview(label)
	return Workspaces.settings.workspaces[index]

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is Workspace:
		return true
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	Workspaces.settings.active_workspace_index = -1
	var over_index = get_item_at_position(at_position)
	var workspace: Workspace = data
	Workspaces.settings.move_workspace(workspace, over_index)
	get_parent().get_parent()._refresh()
	Workspaces.settings.active_workspace_index = over_index

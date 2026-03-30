@tool
class_name WorkspaceSettings
extends Resource

@export var active_workspace_index: int:
	set(value):
		var previous_index = active_workspace_index
		var previous_workspace = get_active_workspace()
		active_workspace_index = value
		active_workspace_changed.emit(active_workspace_index, get_active_workspace(), previous_index, previous_workspace)

@export var workspaces: Array[Workspace]

signal active_workspace_changed(index: int, workspace: Workspace)

func get_active_workspace() -> Workspace:
	if active_workspace_index >= workspaces.size():
		return null
	return workspaces[active_workspace_index]

'''
MIT License

Copyright (c) 2026 Zerbu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
'''
@tool
class_name WorkspaceSettings
extends Resource

@export var active_workspace_index: int:
	set(value):
		if value == active_workspace_index:
			return
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

func get_workspace_by_name(name: String) -> Workspace:
	for workspace in workspaces:
		if workspace.workspace_name == name:
			return workspace
	return null

func set_workspace_by_name(name: String):
	var workspace = get_workspace_by_name(name)
	if not workspace:
		return
	active_workspace_index = workspaces.find(workspace)
	

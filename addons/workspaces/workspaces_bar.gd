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
extends MarginContainer

@onready var workspace_list	: ItemList 		= %WorkspaceList
@onready var menu_button	: MenuButton 	= %MenuButton

var settings_menu: PackedScene = preload("res://addons/workspaces/workspace_settings_menu.tscn")

var _is_refreshing: bool

func _ready() -> void:
	_refresh()
	menu_button.get_popup().id_pressed.connect(_on_menu_button_id_pressed)

func _refresh():
	workspace_list.clear()
	for i in range(Workspaces.settings.workspaces.size()):
		var workspace = Workspaces.settings.workspaces[i]
		workspace_list.add_item(workspace.workspace_name)
		if Workspaces.settings.active_workspace_index == i:
			_is_refreshing = true
			workspace_list.select(workspace_list.item_count-1)
			_is_refreshing = false

func _on_workspace_list_item_selected(index: int) -> void:
	if _is_refreshing: return
	Workspaces.settings.active_workspace_index = index

func _on_menu_button_id_pressed(id: int) -> void:
	match id:
		0:
			_open_workplace_settings()
		1:
			Workspaces.settings.workspaces.erase(Workspaces.settings.get_active_workspace())
			ResourceSaver.save(Workspaces.settings)
			_refresh()
			Workspaces.settings.active_workspace_index = 0
		3:
			var new_workspace = Workspace.new()
			new_workspace.workspace_name = "New Workspace"
			Workspaces.settings.workspaces.append(new_workspace)
			ResourceSaver.save(Workspaces.settings)
			_refresh()
			Workspaces.settings.active_workspace_index = workspace_list.item_count-1
			_open_workplace_settings()
		5:
			Workspace.unhide_controls()
		6:
			_move_workspace(-1)
		7:
			_move_workspace(1)

func _move_workspace(direction: int) -> void:
	var workspace_index = Workspaces.settings.active_workspace_index
	
	var workspace = Workspaces.settings.get_active_workspace()
	if workspace:
		workspace.unapply()
	
	var array = Workspaces.settings.workspaces

	if array.is_empty():
		return

	var old_index = clamp(workspace_index, 0, array.size() - 1)
	var new_index = old_index + direction

	if direction < 0:
		if new_index < 0:
			var item = array.pop_at(old_index)
			array.append(item)
			new_index = array.size() - 1
		else:
			var temp = array[old_index]
			array[old_index] = array[new_index]
			array[new_index] = temp
	else:
		# moving right
		new_index = new_index % array.size()
		var temp = array[old_index]
		array[old_index] = array[new_index]
		array[new_index] = temp

	Workspaces.settings.active_workspace_index = new_index
	_refresh()

func _open_workplace_settings():
	var workspace = Workspaces.settings.get_active_workspace()
	if not workspace: return

	var content: WorkspaceSettingsMenu = settings_menu.instantiate()
	content.workspace = workspace

	var window = GrapplerWindows.open_simple_window(workspace.workspace_name, content)
	window.exclusive = true
	window.close_requested.connect(func():
		_refresh()
	)

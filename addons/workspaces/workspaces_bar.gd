@tool
extends MarginContainer

@onready var workspace_list	: ItemList 		= %WorkspaceList
@onready var menu_button	: MenuButton 	= %MenuButton

var settings_menu: PackedScene = preload("res://addons/workspaces/workspace_settings_menu.tscn")

var _is_refreshing: bool

func _ready() -> void:
	_refresh()
	Workspaces.settings.active_workspace_changed.connect(_on_active_workspace_changed)
	menu_button.get_popup().id_pressed.connect(_on_menu_button_id_pressed)
	var workspace = Workspaces.settings.get_active_workspace()
	if workspace: workspace.apply()

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

func _on_active_workspace_changed(index: int, workspace: Workspace, previous_index: int, previous_workspace: Workspace):
	if previous_workspace: previous_workspace.unapply()
	if workspace == null: return
	workspace_list.select(index)
	workspace.apply()
	ResourceSaver.save(Workspaces.settings)

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
			Workspaces.unhide_controls()
		6:
			var array = Workspaces.settings.workspaces

			if array.is_empty():
				return

			var old_index = clamp(Workspaces.settings.active_workspace_index, 0, array.size() - 1)
			var new_index = old_index - 1

			if new_index < 0:
				var item = array.pop_at(old_index)
				array.append(item)
				Workspaces.settings.active_workspace_index = array.size() - 1
			else:
				var temp = array[old_index]
				array[old_index] = array[new_index]
				array[new_index] = temp
				Workspaces.settings.active_workspace_index = new_index

			_refresh()
		7:
			var old_index = Workspaces.settings.active_workspace_index
			var array = Workspaces.settings.workspaces

			var new_index = (old_index + 1) % array.size()

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

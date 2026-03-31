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
class_name Workspace
extends Resource

# Main Settings
@export var workspace_name				: 	String
@export var layout_name					: 	String
@export var filesystem_auto_navigate	: 	String
@export var auto_set_file_on_unapply	:	bool
@export var auto_set_main_screen		: 	String
@export var force_save_layout			: 	bool
@export var auto_select_script			: 	bool

# Hide Editor Features
@export var hide_menu_bar				: 	bool
@export var hide_main_screen_buttons	: 	bool
@export var hide_run_bar				: 	bool
@export var hide_bottom_bar				: 	bool
@export var hide_tabs_left_1_top		: 	bool
@export var hide_tabs_left_1_bottom		: 	bool
@export var hide_tabs_left_2_top		: 	bool
@export var hide_tabs_left_2_bottom		: 	bool
@export var hide_tabs_right_1_top		: 	bool
@export var hide_tabs_right_1_bottom	: 	bool
@export var hide_tabs_right_2_top		: 	bool
@export var hide_tabs_right_2_bottom	: 	bool
@export var hide_scene_tabs				: 	bool
@export var hide_entire_middle_area		: 	bool

# File Filters
@export var file_filter_names			:	String
@export var file_filter_extensions		:	String

# Auto-Switch
@export var auto_switch_on_script		:	String
@export var auto_switch_on_2d			:	String
@export var auto_switch_on_3d			:	String
@export var auto_switch_on_game			:	String

# Godot 4.7+
@export var hide_tabs_bottom_left		: 	bool
@export var hide_tabs_bottom_right		: 	bool

func apply():
	if layout_name:
		var layout = GrapplerPopupMenuUtils.get_id_from_text(GrapplerTitleBar.editor_layouts_menu, layout_name)
		if layout >= 0:
			GrapplerPopupMenuUtils.simulate_id_pressed(GrapplerTitleBar.editor_layouts_menu, layout)

	if auto_set_main_screen		:	GrapplerTitleBar.set_main_screen_from_string(auto_set_main_screen)

	if hide_menu_bar			:	GrapplerTitleBar.menu_bar.hide()
	if hide_main_screen_buttons	: 	GrapplerTitleBar.main_screen_buttons.hide()
	if hide_run_bar				: 	GrapplerTitleBar.run_bar.hide()

	if hide_menu_bar and hide_main_screen_buttons and hide_run_bar: GrapplerTitleBar.title_bar.hide()
	
	if hide_bottom_bar				:	GrapplerDocks.bottom_panel.tabs_visible							= false
	if hide_tabs_left_1_top			:	GrapplerDocks.left_dock_1_top_tab_container.tabs_visible		= false
	if hide_tabs_left_1_bottom		:	GrapplerDocks.left_dock_1_bottom_tab_container.tabs_visible 	= false
	if hide_tabs_left_2_top			:	GrapplerDocks.left_dock_2_top_tab_container.tabs_visible		= false
	if hide_tabs_left_2_bottom		:	GrapplerDocks.left_dock_2_bottom_tab_container.tabs_visible		= false
	if hide_scene_tabs				:	GrapplerDocks.main_dock_scene_tabs.hide()
	if hide_tabs_right_1_top		:	GrapplerDocks.right_dock_1_top_tab_container.tabs_visible		= false
	if hide_tabs_right_1_bottom		:	GrapplerDocks.right_dock_1_bottom_tab_container.tabs_visible	= false
	if hide_tabs_right_2_top		:	GrapplerDocks.right_dock_2_top_tab_container.tabs_visible		= false
	if hide_tabs_right_2_bottom		:	GrapplerDocks.right_dock_2_bottom_tab_container.tabs_visible	= false
	if hide_entire_middle_area		:	GrapplerDocks.middle_vbox.hide()
	
	# Godot 4.7+
	if GrapplerDocks.has_bottom_docks:
		if hide_tabs_bottom_left	:	GrapplerDocks.bottom_dock_left_tab_container.tabs_visible 		= false
		if hide_tabs_bottom_right	:	GrapplerDocks.bottom_dock_right_tab_container.tabs_visible 		= false

	_unlock_docks				(Engine.get_main_loop().root)
	
	if auto_select_script:
		var script_editor = EditorInterface.get_script_editor()
		script_editor.editor_script_changed.connect(_on_script_editor_script_changed)
		_on_script_editor_script_changed(script_editor.get_current_script())

	if filesystem_auto_navigate:
		# The frame delay is to ensure auto navigate takes priority over Layout changes when setting the scrollbar position 
		await Engine.get_main_loop().process_frame
		GrapplerFileSystem.filesystem_dock.navigate_to_path(filesystem_auto_navigate)

static func unhide_controls():
	GrapplerTitleBar	.menu_bar				.show()
	GrapplerTitleBar	.main_screen_buttons	.show()
	GrapplerTitleBar	.run_bar				.show()
	GrapplerTitleBar	.title_bar				.show()
	GrapplerDocks		.main_dock_scene_tabs	.show()
	GrapplerDocks		.middle_vbox			.show()
	
	GrapplerDocks.bottom_panel.tabs_visible							= true
	GrapplerDocks.left_dock_1_top_tab_container.tabs_visible		= true
	GrapplerDocks.left_dock_1_bottom_tab_container.tabs_visible		= true
	GrapplerDocks.left_dock_2_top_tab_container.tabs_visible		= true
	GrapplerDocks.left_dock_2_bottom_tab_container.tabs_visible		= true
	GrapplerDocks.right_dock_1_top_tab_container.tabs_visible		= true
	GrapplerDocks.right_dock_1_bottom_tab_container.tabs_visible	= true
	GrapplerDocks.right_dock_2_top_tab_container.tabs_visible		= true
	GrapplerDocks.right_dock_2_bottom_tab_container.tabs_visible	= true
	
	# Godot 4.7+
	if GrapplerDocks.has_bottom_docks:
		GrapplerDocks.bottom_dock_left_tab_container.tabs_visible 	= true
		GrapplerDocks.bottom_dock_right_tab_container.tabs_visible 	= true
	

func apply_filter():
	if file_filter_names:
		GrapplerTreeUtils.filter(GrapplerFileSystem.main_tree.get_root(),
		func(item: TreeItem):
			var text = item.get_text(0)
			for file_name in file_filter_names.replace("\r", "").split("\n"):
				if text == file_name:
					return true
			return false
		)
	if file_filter_extensions:
		GrapplerTreeUtils.filter(GrapplerFileSystem.main_tree.get_root(),
		func(item: TreeItem):
			var text = item.get_text(0)
			for extension in file_filter_extensions.replace("\r", "").split("\n"):
				if not extension.begins_with("."):
					extension = ".%s" % extension
				if text.get_file().ends_with(extension):
					return true
			return false
		)

func reapply():
	unapply()
	apply()

func unapply():
	Workspace.unhide_controls()
	
	if force_save_layout:
		GrapplerLayoutsDialog.force_save_layout(layout_name)

	if auto_set_file_on_unapply:
		filesystem_auto_navigate = EditorInterface.get_current_path()
	
	if auto_select_script:
		var script_editor = EditorInterface.get_script_editor()
		script_editor.editor_script_changed.disconnect(_on_script_editor_script_changed)

func _unlock_docks(node: Node):
	for child in node.get_children():
		if child is EditorDock:
			child.available_layouts = EditorDock.DOCK_LAYOUT_ALL
		_unlock_docks(child)

func _on_process():
	if auto_switch_on_2d and GrapplerDocks.node_2d_and_ui_editor.is_visible_in_tree():
		Workspaces.settings.set_workspace_by_name(auto_switch_on_2d)
	elif auto_switch_on_3d and GrapplerDocks.node_3d_editor.is_visible_in_tree():
		Workspaces.settings.set_workspace_by_name(auto_switch_on_3d)
	elif auto_switch_on_script and GrapplerDocks.script_editor.is_visible_in_tree():
		Workspaces.settings.set_workspace_by_name(auto_switch_on_script)
	elif auto_switch_on_game and GrapplerDocks.game_view.is_visible_in_tree():
		Workspaces.settings.set_workspace_by_name(auto_switch_on_game)

func _on_script_editor_script_changed(new_script: Script):
	if not new_script: return
	# This is intentionally delayed so that it applies even when changing layouts
	await Engine.get_main_loop().create_timer(0.2).timeout
	GrapplerFileSystem.filesystem_dock.navigate_to_path(new_script.resource_path)

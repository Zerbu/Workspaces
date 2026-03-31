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
class_name WorkspaceSettingsMenu
extends Control

@export var workspace: Workspace

@onready var workspace_name							: LineEdit			= %WorkspaceName
@onready var layout_name							: LineEdit			= %LayoutName
@onready var file_system_auto_navigate				: LineEdit			= %FileSystemAutoNavigate
@onready var auto_set_file_on_unapply				: CheckBox			= %AutoSetFileOnUnapply
@onready var auto_set_main_screen_option_button		: OptionButton		= %AutoSetMainScreenOptionButton
@onready var auto_set_main_screen_line_edit			: LineEdit			= %AutoSetMainScreenLineEdit
@onready var force_save_layout						: CheckBox 			= %ForceSaveLayout
@onready var auto_select_script						: CheckBox 			= %AutoSelectScript

@onready var hide_menu_bar							: CheckBox			= %HideMenuBar
@onready var hide_main_screen_buttons				: CheckBox			= %HideMainScreenButtons
@onready var hide_run_bar							: CheckBox			= %HideRunBar
@onready var hide_bottom_bar						: CheckBox			= %HideBottomBar

@onready var hide_left_docks_1_top					: CheckBox			= %LeftDocks1Top
@onready var hide_left_docks_1_bottom				: CheckBox			= %LeftDocks1Bottom
@onready var hide_left_docks_2_top					: CheckBox			= %LeftDocks2Top
@onready var hide_left_docks_2_bottom				: CheckBox			= %LeftDocks2Bottom

@onready var hide_scene_tabs						: CheckBox			= %SceneTabs

@onready var hide_right_docks_1_top					: CheckBox			= %RightDocks1Top
@onready var hide_right_docks_1_bottom				: CheckBox			= %RightDocks1Bottom
@onready var hide_right_docks_2_top					: CheckBox			= %RightDocks2Top
@onready var hide_right_docks_2_bottom				: CheckBox			= %RightDocks2Bottom

@onready var hide_bottom_docks_left					: CheckBox			= %BottomDocksLeft
@onready var hide_bottom_docks_right				: CheckBox			= %BottomDocksRight

@onready var hide_entire_middle_area				: CheckBox			= %HideEntireMiddleArea

@onready var file_filter_extensions					: TextEdit			= %FileFilterExtensions
@onready var file_filter_names						: TextEdit			= %FileFilterNames

@onready var auto_switch_on_2d						: MarginContainer 	= %AutoSwitchOn2D
@onready var auto_switch_on_3d						: MarginContainer 	= %AutoSwitchOn3D
@onready var auto_switch_on_script					: MarginContainer 	= %AutoSwitchOnScript
@onready var auto_switch_on_game					: MarginContainer 	= %AutoSwitchOnGame

@onready var file_dialog							: FileDialog	= %FileDialog


func _ready() -> void:
	if not workspace:
		return

	workspace_name.text							= workspace.workspace_name
	layout_name.text							= workspace.layout_name
	file_system_auto_navigate.text				= workspace.filesystem_auto_navigate
	auto_set_file_on_unapply.button_pressed		= workspace.auto_set_file_on_unapply
	auto_set_main_screen_line_edit.text			= workspace.auto_set_main_screen

	force_save_layout.button_pressed			= workspace.force_save_layout
	
	auto_select_script.button_pressed			= workspace.auto_select_script

	hide_menu_bar.button_pressed				= workspace.hide_menu_bar
	hide_main_screen_buttons.button_pressed		= workspace.hide_main_screen_buttons
	hide_run_bar.button_pressed					= workspace.hide_run_bar
	hide_bottom_bar.button_pressed				= workspace.hide_bottom_bar

	hide_left_docks_1_top.button_pressed		= workspace.hide_tabs_left_1_top
	hide_left_docks_1_bottom.button_pressed		= workspace.hide_tabs_left_1_bottom
	hide_left_docks_2_top.button_pressed		= workspace.hide_tabs_left_2_top
	hide_left_docks_2_bottom.button_pressed		= workspace.hide_tabs_left_2_bottom

	hide_scene_tabs.button_pressed				= workspace.hide_scene_tabs

	hide_right_docks_1_top.button_pressed		= workspace.hide_tabs_right_1_top
	hide_right_docks_1_bottom.button_pressed	= workspace.hide_tabs_right_1_bottom
	hide_right_docks_2_top.button_pressed		= workspace.hide_tabs_right_2_top
	hide_right_docks_2_bottom.button_pressed	= workspace.hide_tabs_right_2_bottom

	hide_entire_middle_area.button_pressed		= workspace.hide_entire_middle_area
	
	hide_bottom_docks_left.button_pressed		= workspace.hide_tabs_bottom_left
	hide_bottom_docks_right.button_pressed		= workspace.hide_tabs_bottom_right

	file_filter_extensions.text					= workspace.file_filter_extensions
	file_filter_names.text						= workspace.file_filter_names
	
	auto_switch_on_2d.value						= workspace.auto_switch_on_2d
	auto_switch_on_3d.value						= workspace.auto_switch_on_3d
	auto_switch_on_script.value					= workspace.auto_switch_on_script
	auto_switch_on_game.value					= workspace.auto_switch_on_game

	_update_option_button()

func _on_close_button_pressed() -> void:
	workspace.workspace_name					= workspace_name.text
	workspace.layout_name						= layout_name.text
	workspace.filesystem_auto_navigate			= file_system_auto_navigate.text
	workspace.auto_set_file_on_unapply			= auto_set_file_on_unapply.button_pressed
	workspace.auto_set_main_screen				= auto_set_main_screen_line_edit.text

	workspace.force_save_layout					= force_save_layout.button_pressed
	
	workspace.auto_select_script				= auto_select_script.button_pressed

	workspace.hide_menu_bar						= hide_menu_bar.button_pressed
	workspace.hide_main_screen_buttons			= hide_main_screen_buttons.button_pressed
	workspace.hide_run_bar						= hide_run_bar.button_pressed
	workspace.hide_bottom_bar					= hide_bottom_bar.button_pressed

	workspace.hide_tabs_left_1_top				= hide_left_docks_1_top.button_pressed
	workspace.hide_tabs_left_1_bottom			= hide_left_docks_1_bottom.button_pressed
	workspace.hide_tabs_left_2_top				= hide_left_docks_2_top.button_pressed
	workspace.hide_tabs_left_2_bottom			= hide_left_docks_2_bottom.button_pressed

	workspace.hide_scene_tabs					= hide_scene_tabs.button_pressed

	workspace.hide_tabs_right_1_top 			= hide_right_docks_1_top.button_pressed
	workspace.hide_tabs_right_1_bottom			= hide_right_docks_1_bottom.button_pressed
	workspace.hide_tabs_right_2_top				= hide_right_docks_2_top.button_pressed
	workspace.hide_tabs_right_2_bottom			= hide_right_docks_2_bottom.button_pressed

	workspace.hide_entire_middle_area			= hide_entire_middle_area.button_pressed
	
	workspace.hide_tabs_bottom_left				= hide_bottom_docks_left.button_pressed
	workspace.hide_tabs_bottom_right			= hide_bottom_docks_right.button_pressed

	workspace.file_filter_extensions			= file_filter_extensions.text
	workspace.file_filter_names					= file_filter_names.text

	workspace.auto_switch_on_2d 				= auto_switch_on_2d.value
	workspace.auto_switch_on_3d 				= auto_switch_on_3d.value
	workspace.auto_switch_on_script 			= auto_switch_on_script.value
	workspace.auto_switch_on_game				= auto_switch_on_game.value

	ResourceSaver.save(Workspaces.settings)

	workspace.reapply()

	GrapplerWindows.close_window_of_node(self)

func _update_option_button():
	for i in range(auto_set_main_screen_option_button.item_count):
		var text = auto_set_main_screen_option_button.get_item_text(i)
		if text == auto_set_main_screen_line_edit.text:
			auto_set_main_screen_option_button.select(i)
			return
	auto_set_main_screen_option_button.select(0)

func _on_auto_set_main_screen_line_edit_text_changed(new_text: String) -> void:
	_update_option_button()

func _on_auto_set_main_screen_option_button_item_selected(index: int) -> void:
	var text = auto_set_main_screen_option_button.get_item_text(index)
	auto_set_main_screen_line_edit.text = text

func _on_browse_button_pressed() -> void:
	file_dialog.show()

func _on_file_dialog_file_selected(path: String) -> void:
	file_system_auto_navigate.text = path

@tool
class_name WorkspaceSettingsMenu
extends Control

@export var workspace: Workspace

@onready var workspace_name						: LineEdit 		= %WorkspaceName
@onready var layout_name						: LineEdit 		= %LayoutName
@onready var file_system_auto_navigate			: LineEdit 		= %FileSystemAutoNavigate
@onready var auto_set_file_on_unapply			: CheckBox 		= %AutoSetFileOnUnapply
@onready var auto_set_main_screen_option_button	: OptionButton 	= %AutoSetMainScreenOptionButton
@onready var auto_set_main_screen_line_edit		: LineEdit 		= %AutoSetMainScreenLineEdit

@onready var hide_menu_bar						: CheckBox 		= %HideMenuBar
@onready var hide_main_screen_buttons			: CheckBox 		= %HideMainScreenButtons
@onready var hide_run_bar						: CheckBox 		= %HideRunBar
@onready var hide_bottom_bar					: CheckBox 		= %HideBottomBar
@onready var hide_top_left_dock_1				: CheckBox 		= %TopLeftDock1
@onready var hide_bottom_left_dock_1			: CheckBox 		= %BottomLeftDock1
@onready var hide_top_left_dock_2				: CheckBox 		= %TopLeftDock2
@onready var hide_bottom_left_dock_2			: CheckBox 		= %BottomLeftDock2
@onready var hide_scene_tabs					: CheckBox 		= %SceneTabs
@onready var hide_top_right_dock_1				: CheckBox 		= %TopRightDock1
@onready var hide_bottom_right_dock_1			: CheckBox 		= %BottomRightDock1
@onready var hide_top_right_dock_2				: CheckBox 		= %TopRightDock2
@onready var hide_bottom_right_dock_2			: CheckBox		= %BottomRightDock2
@onready var hide_entire_middle_area			: CheckBox 		= %HideEntireMiddleArea

@onready var file_filter_extensions				: TextEdit 		= %FileFilterExtensions
@onready var file_filter_names					: TextEdit 		= %FileFilterNames

@onready var file_dialog						: FileDialog 	= %FileDialog

func _ready() -> void:
	if not workspace: return
	workspace_name.text							= workspace.workspace_name
	layout_name.text 							= workspace.layout_name
	file_system_auto_navigate.text 				= workspace.filesystem_auto_navigate
	auto_set_file_on_unapply.button_pressed 	= workspace.auto_set_file_on_unapply
	auto_set_main_screen_line_edit.text 		= workspace.auto_set_main_screen
	hide_menu_bar.button_pressed 				= workspace.hide_menu_bar
	hide_main_screen_buttons.button_pressed 	= workspace.hide_main_screen_buttons
	hide_run_bar.button_pressed 				= workspace.hide_run_bar
	hide_bottom_bar.button_pressed 				= workspace.hide_bottom_bar
	hide_top_left_dock_1.button_pressed 		= workspace.hide_tabs_left_1_top
	hide_bottom_left_dock_1.button_pressed 		= workspace.hide_tabs_left_1_bottom
	hide_top_left_dock_2.button_pressed 		= workspace.hide_tabs_left_2_top
	hide_bottom_left_dock_2.button_pressed 		= workspace.hide_tabs_left_2_bottom
	hide_scene_tabs.button_pressed 				= workspace.hide_scene_tabs
	hide_top_right_dock_1.button_pressed 		= workspace.hide_tabs_right_1_top
	hide_bottom_right_dock_1.button_pressed 	= workspace.hide_tabs_right_1_bottom
	hide_top_right_dock_2.button_pressed 		= workspace.hide_tabs_right_2_top
	hide_bottom_right_dock_2.button_pressed 	= workspace.hide_tabs_right_2_bottom
	hide_entire_middle_area.button_pressed 		= workspace.hide_entire_middle_area
	file_filter_extensions.text 				= workspace.file_filter_extensions
	file_filter_names.text 						= workspace.file_filter_names
	
	_update_option_button()

func _on_close_button_pressed() -> void:
	workspace.workspace_name 					= workspace_name.text
	workspace.layout_name 						= layout_name.text
	workspace.filesystem_auto_navigate 			= file_system_auto_navigate.text
	workspace.auto_set_file_on_unapply 			= auto_set_file_on_unapply.button_pressed
	workspace.auto_set_main_screen 				= auto_set_main_screen_line_edit.text
	workspace.hide_menu_bar 					= hide_menu_bar.button_pressed
	workspace.hide_main_screen_buttons 			= hide_main_screen_buttons.button_pressed
	workspace.hide_run_bar 						= hide_run_bar.button_pressed
	workspace.hide_bottom_bar 					= hide_bottom_bar.button_pressed
	workspace.hide_tabs_left_1_top 				= hide_top_left_dock_1.button_pressed
	workspace.hide_tabs_left_1_bottom 			= hide_bottom_left_dock_1.button_pressed
	workspace.hide_tabs_left_2_top 				= hide_top_left_dock_2.button_pressed
	workspace.hide_tabs_left_2_bottom 			= hide_bottom_left_dock_2.button_pressed
	workspace.hide_scene_tabs 					= hide_scene_tabs.button_pressed
	workspace.hide_tabs_right_1_top 			= hide_top_right_dock_1.button_pressed
	workspace.hide_tabs_right_1_bottom 			= hide_bottom_right_dock_1.button_pressed
	workspace.hide_tabs_right_2_top 			= hide_top_right_dock_2.button_pressed
	workspace.hide_tabs_right_2_bottom 			= hide_bottom_right_dock_2.button_pressed
	workspace.hide_entire_middle_area 			= hide_entire_middle_area.button_pressed
	workspace.file_filter_extensions 			= file_filter_extensions.text
	workspace.file_filter_names 				= file_filter_names.text
	
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

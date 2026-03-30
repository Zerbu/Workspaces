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
class_name Workspaces
extends EditorPlugin

static var workspaces_bar = preload("res://addons/workspaces/workspaces_bar.tscn").instantiate()

static var settings: WorkspaceSettings:
	get:
		if not settings:
			if ResourceLoader.exists("res://workspaces.tres"):
				settings = ResourceLoader.load("res://workspaces.tres")
			else:
				settings = ResourceLoader.load("res://addons/workspaces/default_workspaces.tres").duplicate(true)
				settings.take_over_path("res://workspaces.tres")
		return settings	

var filter_timer: Timer

func _enter_tree() -> void:
	GrapplerBase.root_vbox.add_child	(workspaces_bar)
	GrapplerBase.root_vbox.move_child	(workspaces_bar, 0)
	
	if not filter_timer:
		filter_timer = Timer.new()
	filter_timer.wait_time = 1.0
	add_child(filter_timer)
	filter_timer.timeout.connect(_on_filter_timer_timeout)
	filter_timer.start()

func _exit_tree() -> void:
	GrapplerBase.root_vbox.remove_child	(workspaces_bar)
	filter_timer.timeout.disconnect		(_on_filter_timer_timeout)
	filter_timer.stop()
	filter_timer.queue_free()

func _on_filter_timer_timeout():
	var workspace = Workspaces.settings.get_active_workspace()
	if not workspace: return
	workspace.apply_filter()

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

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

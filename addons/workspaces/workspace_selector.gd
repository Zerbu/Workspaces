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

var is_refreshing	: bool

@export	var value: String:
	set(new_value):
		value = new_value
		_refresh.call_deferred()
		
@onready	var option_button	: OptionButton 	= %OptionButton
@onready	var line_edit		: LineEdit 		= %LineEdit

func _ready() -> void:
	if not get_owner(): return
	option_button.clear()
	option_button.add_item("")
	for workspace in Workspaces.settings.workspaces:
		option_button.add_item(workspace.workspace_name)

func _on_line_edit_text_changed(new_text: String) -> void:
	if is_refreshing: return
	value = new_text

func _on_option_button_item_selected(index: int) -> void:
	if is_refreshing: return
	value = option_button.get_item_text(index)

func _refresh():
	is_refreshing = true
	line_edit.text = value
	for i in range(option_button.item_count-1):
		var text = option_button.get_item_text(i)
		if text == line_edit.text:
			option_button.select(i)
	is_refreshing = false

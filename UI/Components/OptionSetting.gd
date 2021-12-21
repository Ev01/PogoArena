extends OptionButton
## Simple button sets value to the text of the selected item

signal value_changed(value)

var value setget _set_value
# Key = item_text, Value = item_id
var value_names = {}

func _ready():
	connect("item_selected", self, "_on_item_selected")
	value = get_item_text(get_selected_id())
	
	for item_id in range(get_item_count()):
		value_names[get_item_text(item_id)] = item_id


func _on_item_selected(item_id):
	_set_value(get_item_text(item_id))


func _set_value(val):
	value = val
	select(value_names[val])
	emit_signal("value_changed", value)

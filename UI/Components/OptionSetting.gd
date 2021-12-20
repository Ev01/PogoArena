extends OptionButton
## Simple button sets value to the text of the selected item

var value

func _ready():
	connect("item_selected", self, "_on_item_selected")
	value = get_item_text(get_selected_id())
#	for item_id in range(get_item_count()):
#		values.append(get_item_text(item_id))


func _on_item_selected(item_id):
	value = get_item_text(item_id)

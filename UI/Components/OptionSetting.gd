extends OptionButton
## Simple button sets value to the text of the selected item

var value

func _ready():
	connect("item_selected", self, "_on_item_selected")
	value = get_item_text(get_selected_id())


func _on_item_selected(item_id):
	value = get_item_text(item_id)

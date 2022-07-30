extends Resource

class_name MatchSettingsData

# TODO: Remove dictionary and make multiple variables instead
var settings = {}

func set_setting(setting_name : String, value):
	settings[setting_name] = value

func get_setting(setting_name : String):
	if settings.has(setting_name):
		return settings[setting_name]
	else:
		return null

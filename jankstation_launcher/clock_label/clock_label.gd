class_name ClockLabel
extends RichTextLabel


func _process(delta: float) -> void:
	var datetime_dict: Dictionary = Time.get_datetime_dict_from_system()
	var hour: int = datetime_dict.hour % 12
	var minute: int = datetime_dict.minute
	
	var am_pm_str: String = "am"
	if datetime_dict.hour >= 12:
		am_pm_str = "pm"
	if hour == 00:
		hour = 12	
	
	var final_str: String = "%02d:%02d" % [hour, minute] + am_pm_str
	text = "[right]" + final_str + "[/right]"

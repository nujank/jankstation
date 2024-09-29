class_name DemoData
extends RefCounted


var title: String = ""
var description: String = ""
var thumbnail: Texture2D = null
var has_played: bool = false


func _init(_title: String, _description: String, _thumbnail: Texture2D, _has_played: bool) -> void:
	title = _title
	description = _description
	thumbnail = _thumbnail
	has_played = _has_played

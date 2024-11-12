class_name DemoData
extends RefCounted


var title: String = ""
var author: String = ""
var description: String = ""
var exe_filepath: String = ""
var thumbnail: Texture2D = null
var has_played: bool = false


func _init(_title: String, _author: String, _description: String, _filepath: String, _thumbnail: Texture2D, _has_played: bool) -> void:
	title = _title
	author = _author
	description = _description
	exe_filepath = _filepath
	thumbnail = _thumbnail
	has_played = _has_played

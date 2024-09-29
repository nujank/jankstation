class_name Splash
extends Node3D


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("fade_in")
	await animation_player.animation_finished
	App.instance.change_scene("main_menu")

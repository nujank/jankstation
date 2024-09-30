class_name Splash
extends Node3D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
const MAGNET_ACTION = preload("res://app_scenes/splash/magnet_action.wav")

func _ready() -> void:
	animation_player.play("fade_in")
	await animation_player.animation_finished
	App.instance.change_scene("main_menu")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed == true && event.button_index == MOUSE_BUTTON_LEFT:
		var asp: AudioStreamPlayer = AudioStreamPlayer.new()
		asp.stream = MAGNET_ACTION
		asp.volume_db = -10
		asp.pitch_scale = randf_range(0.8, 1.25)
		asp.finished.connect(func(): asp.queue_free())
		add_child(asp)
		asp.play()

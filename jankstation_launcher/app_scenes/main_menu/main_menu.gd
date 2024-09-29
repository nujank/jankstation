class_name MainMenu
extends Node3D


@onready var demo_browser_button: Button = $ButtonContainer/DemoBrowserButton
@onready var config_button: Button = $ButtonContainer/ConfigButton
@onready var exit_button: Button = $ButtonContainer/ExitButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var button_container: VBoxContainer = $ButtonContainer


func _ready() -> void:	
	App.instance.title_bar.hide_home_button()
	App.instance.title_bar.set_title_label_text("JankStation")
	
	animation_player.play("trans_in")
	await animation_player.animation_finished
	
	App.instance.resume_audio()
	
	button_container.show()
	
	demo_browser_button.pressed.connect(on_demo_browser_button_pressed)
	config_button.pressed.connect(on_config_button_pressed)
	exit_button.pressed.connect(on_exit_button_pressed)


func on_demo_browser_button_pressed() -> void:
	button_container.hide()
	animation_player.play("trans_out")
	await animation_player.animation_finished
	App.instance.change_scene_instant("demo_browser")
	
	
func on_config_button_pressed() -> void:
	button_container.hide()
	animation_player.play("trans_out")
	await animation_player.animation_finished
	App.instance.change_scene_instant("config_menu")
	
	
func on_exit_button_pressed() -> void:
	get_tree().quit()

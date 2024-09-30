class_name MainMenu
extends Node3D


@onready var demo_browser_button: Button = $ButtonContainer/DemoBrowserButton
@onready var config_button: Button = $ButtonContainer/ConfigButton
@onready var exit_button: Button = $ButtonContainer/ExitButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var button_container: VBoxContainer = $ButtonContainer

@onready var click_sfx: AudioStreamPlayer = $ClickSFX
@onready var select_sfx: AudioStreamPlayer = $SelectSFX


func _ready() -> void:
	demo_browser_button.mouse_entered.connect(on_demo_browser_button_mouse_entered)
	config_button.mouse_entered.connect(on_config_button_mouse_entered)
	exit_button.mouse_entered.connect(on_exit_button_mouse_entered)
	
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
	select_sfx.play()
	button_container.hide()
	animation_player.play("trans_out")
	await animation_player.animation_finished
	App.instance.change_scene_instant("demo_browser")
	
	
func on_demo_browser_button_mouse_entered() -> void:
	click_sfx.play()
	
	
func on_config_button_pressed() -> void:
	select_sfx.play()
	button_container.hide()
	animation_player.play("trans_out")
	await animation_player.animation_finished
	App.instance.change_scene_instant("config_menu")
	
	
func on_config_button_mouse_entered() -> void:
	click_sfx.play()
	
	
func on_exit_button_pressed() -> void:
	select_sfx.play()
	get_tree().quit()


func on_exit_button_mouse_entered() -> void:
	click_sfx.play()

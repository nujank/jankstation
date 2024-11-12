class_name ConfigMenu
extends Node3D

@onready var node_3d: Node3D = $Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var v_box_container: VBoxContainer = $VBoxContainer

@onready var fullscreen_check_box: CheckBox = $VBoxContainer/HBoxContainer2/CheckBox
@onready var music_volume_slider: HSlider = $VBoxContainer/MusicVolumeSlider
@onready var sfx_volume_slider: HSlider = $VBoxContainer/SFXVolumeSlider

@onready var clear_user_data_button: Button = $VBoxContainer/ClearUserDataButton


func _ready() -> void:	
	App.instance.title_bar.show_home_button()
	App.instance.title_bar.set_title_label_text("Config")
	
	App.instance.title_bar.home_button_pressed.connect(on_title_bar_home_button_pressed)
	
	fullscreen_check_box.button_pressed = App.instance.is_fullscreen
	music_volume_slider.value = App.instance.music_volume #db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("BGM")))
	sfx_volume_slider.value = App.instance.sfx_volume #db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	
	animation_player.play("trans_in")
	await animation_player.animation_finished
	
	fullscreen_check_box.toggled.connect(on_fullscreen_check_box_toggled)
	music_volume_slider.value_changed.connect(on_music_volume_slider_value_changed)
	sfx_volume_slider.value_changed.connect(on_sfx_volume_slider_value_changed)
	clear_user_data_button.pressed.connect(on_clear_user_data_button_pressed)


func _process(delta: float) -> void:
	node_3d.rotation.y += delta


func on_exit() -> bool:
	animation_player.play("trans_out")
	await animation_player.animation_finished
	return true
	
	
func on_title_bar_home_button_pressed() -> void:
	v_box_container.hide()
	
	animation_player.play("trans_out")
	await animation_player.animation_finished
	App.instance.change_scene_instant("main_menu")


func on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	App.instance.set_fullscreen(toggled_on)
		
		
func on_music_volume_slider_value_changed(value: float) -> void:
	var music_index: int = AudioServer.get_bus_index("BGM")
	AudioServer.set_bus_volume_db(music_index, linear_to_db(value))
	
	App.instance.set_music_volume(value)


func on_sfx_volume_slider_value_changed(value: float) -> void:
	var sfx_index: int = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(value))
	
	App.instance.set_sfx_volume(value)
		
	
func on_clear_user_data_button_pressed() -> void:
	DirAccess.remove_absolute("user://demo_data.cfg")

class_name TitleBar
extends Control


signal home_button_pressed


@onready var placeholder_rect: ColorRect = $MarginContainer/Control/HBoxContainer/PlaceholderRect
@onready var home_button: TextureButton = $MarginContainer/Control/HBoxContainer/HomeButton
@onready var title_label: RichTextLabel = $MarginContainer/Control/HBoxContainer/TitleLabel

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var home_sfx: AudioStreamPlayer = $HomeSFX


func _ready() -> void:
	home_button.pressed.connect(on_home_button_pressed)


func slide_up() -> bool:
	animation_player.play("slide_up")
	await animation_player.animation_finished
	return true
	
	
func slide_down() -> bool:
	animation_player.play("slide_down")
	await animation_player.animation_finished
	return true
	
	
func set_title_label_text(text: String) -> void:
	title_label.text = text


func show_home_button() -> void:
	placeholder_rect.hide()
	home_button.show()
	
	
func hide_home_button() -> void:
	placeholder_rect.show()
	home_button.hide()


func on_home_button_pressed() -> void:
	home_sfx.play()
	home_button_pressed.emit()

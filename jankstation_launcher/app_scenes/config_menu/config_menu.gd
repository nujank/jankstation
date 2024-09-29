class_name ConfigMenu
extends Node3D

@onready var node_3d: Node3D = $Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var v_box_container: VBoxContainer = $VBoxContainer


func _ready() -> void:	
	App.instance.title_bar.show_home_button()
	App.instance.title_bar.set_title_label_text("Config")
	
	App.instance.title_bar.home_button_pressed.connect(on_title_bar_home_button_pressed)
	
	animation_player.play("trans_in")
	await animation_player.animation_changed


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

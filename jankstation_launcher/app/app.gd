class_name App
extends Node


static var instance


var current_scene_inst: Node = null

@onready var scene_root: Node = $SceneRoot
@onready var screen_fade: ScreenFade = $ScreenFade

@onready var background_grid: MeshInstance3D = $Camera3D/BackgroundGrid
@onready var wireframe_sphere: MeshInstance3D = $Camera3D/WireframeSphere
@onready var bgm_audio: AudioStreamPlayer = $BGMAudio

@onready var title_bar: TitleBar = $TitleBar
@onready var version_label: RichTextLabel = $VersionLabel

var ticks: float = 0.0


func _ready() -> void:
	instance = self
	
	background_grid.mesh = MeshUtils.build_wireframe_grid_mesh(32, background_grid.material_override)
	
	load_scene("boot")
	change_scene("splash")
	#change_scene("main_menu")
	
	
func _process(delta: float) -> void:
	wireframe_sphere.rotation.y += delta * 0.0125
	wireframe_sphere.rotation.x = sin(ticks * 0.01) * deg_to_rad(1)
	ticks += 1


func change_scene(scene_name: String, fade_out_duration: float = 1.0, fade_in_duration: float = 1.0) -> void:
	screen_fade.color = Color.BLACK
	await screen_fade.fade_out(fade_out_duration)
	
	unload_current_scene()

	# wait a frame for scene to be fully freed
	await get_tree().process_frame
	
	load_scene(scene_name)
	
	await screen_fade.fade_in(fade_in_duration)
	
	
func change_scene_instant(scene_name: String) -> void:
	await title_bar.slide_up()
	unload_current_scene()
	await get_tree().process_frame
	load_scene(scene_name)
	await title_bar.slide_down()


func load_scene(scene_name: String) -> void:
	var path: String = "res://app_scenes/%s/%s.tscn" % [scene_name, scene_name]
	var scene_pack: PackedScene = load(path)
	if scene_pack != null:
		var scene_inst = scene_pack.instantiate()
		scene_root.add_child(scene_inst)
		current_scene_inst = scene_inst


func unload_current_scene() -> void:
	if is_instance_valid(current_scene_inst) == true:
		current_scene_inst.queue_free()
	current_scene_inst = null


func pause() -> void:
	get_tree().paused = true
	

func resume() -> void:
	get_tree().paused = false


func pause_audio() -> void:
	bgm_audio.stop()
	
	
func resume_audio() -> void:
	if bgm_audio.playing == false:
		bgm_audio.play()


func show_version_label() -> void:
	version_label.text = ProjectSettings.get_setting("application/config/version")
	version_label.show()

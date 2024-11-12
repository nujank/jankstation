class_name DemoBrowser
extends Node3D


@export var demo_block_packed: PackedScene

@onready var demo_block_grid: Node3D = $GridContainer/DemoBlockGrid
@onready var up_arrow: StaticBody3D = $GridContainer/UpArrow
@onready var up_arrow_mesh: MeshInstance3D = $GridContainer/UpArrow/UpArrowMesh

@onready var down_arrow: StaticBody3D = $GridContainer/DownArrow
@onready var down_arrow_mesh: MeshInstance3D = $GridContainer/DownArrow/DownArrowMesh

@onready var demo_title_label: RichTextLabel = $ScrollContainer/VBoxContainer/DemoTitleLabel
@onready var demo_author_label: RichTextLabel = $ScrollContainer/VBoxContainer/DemoAuthorLabel
@onready var demo_description_label: RichTextLabel = $ScrollContainer/VBoxContainer/DemoDescriptionLabel
@onready var overlay: ColorRect = $Overlay

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var block_offset: float = 1.5

var demo_path: String = OS.get_executable_path().get_base_dir() + "/demo_data"
var test_demo_path: String = "res://test_demo_data"
var demo_data_array: Array[DemoData] = []
var has_played_dict: Dictionary = {}

var scroll_index: int = 0
var current_demo_pid: int = -1

var up_arrow_hovered: bool = false
var down_arrow_hovered: bool = false

@onready var arrow_hovered_sfx: AudioStreamPlayer = $ArrowHoveredSFX
@onready var arrow_selected_sfx: AudioStreamPlayer = $ArrowSelectedSFX

var is_hovering_info_scroll: bool = false


func _ready() -> void:
	App.instance.title_bar.show_home_button()
	App.instance.title_bar.set_title_label_text("Demo Browser")
	
	App.instance.title_bar.home_button_pressed.connect(on_title_bar_home_button_pressed)
	
	up_arrow_mesh.mesh = MeshUtils.build_line_mesh(MeshUtils.generate_triangle_mesh_data(0.35), up_arrow_mesh.material_override)
	up_arrow.input_event.connect(on_up_arrow_input_event)
	up_arrow.mouse_entered.connect(on_up_arrow_mouse_entered)
	up_arrow.mouse_exited.connect(on_up_arrow_mouse_exited)
	down_arrow_mesh.mesh = MeshUtils.build_line_mesh(MeshUtils.generate_triangle_mesh_data(0.35), down_arrow_mesh.material_override)
	down_arrow.input_event.connect(on_down_arrow_input_event)
	down_arrow.mouse_entered.connect(on_down_arrow_mouse_entered)
	down_arrow.mouse_exited.connect(on_down_arrow_mouse_exited)
	
	load_demo_data()
	setup_demo_block_grid()
	
	animation_player.play("trans_in")
	await animation_player.animation_finished
	
	$ScrollContainer.mouse_entered.connect(on_scroll_container_mouse_entered)
	$ScrollContainer.mouse_exited.connect(on_scroll_container_mouse_exited)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed && is_hovering_info_scroll == false:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			scroll_index -= 4
			if scroll_index < 0:
				scroll_index = 0
			load_demo_data()
			setup_demo_block_grid()
			arrow_selected_sfx.play()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			scroll_index += 4
			if scroll_index > demo_data_array.size():
				scroll_index -= 4
			load_demo_data()
			setup_demo_block_grid()
			arrow_selected_sfx.play()
	
	
func _process(delta: float) -> void:
	if OS.is_process_running(current_demo_pid) == true:
		overlay.show()			
	else:
		if current_demo_pid >= 0:
			overlay.hide()
			load_demo_data()
			setup_demo_block_grid()
			App.instance.resume_audio()
			current_demo_pid = -1
			
			
	if up_arrow_hovered == true:
		up_arrow.scale = lerp(up_arrow.scale, Vector3(1.5, 1.5, 1.5), delta * 20)
	else:
		up_arrow.scale = lerp(up_arrow.scale, Vector3(1.0, 1.0, 1.0), delta * 20)
		
		
	if down_arrow_hovered == true:
		down_arrow.scale = lerp(down_arrow.scale, Vector3(1.5, 1.5, 1.5), delta * 20)
	else:
		down_arrow.scale = lerp(down_arrow.scale, Vector3(1.0, 1.0, 1.0), delta * 20)
	
	
func load_demo_data() -> void:
	demo_data_array.clear()
	has_played_dict.clear()
	
	# load saved data
	var config: ConfigFile = ConfigFile.new()
	var err = config.load("user://demo_data.cfg")
	if err == OK:
		for demo_entry in config.get_sections():
			var has_played = config.get_value(demo_entry, "has_played")
			has_played_dict[demo_entry] = has_played
			
	# scan demo data directory
	var demo_data_dir = DirAccess.open(demo_path)
	if demo_data_dir:
		demo_data_dir.list_dir_begin()
		var demo_dir_name: String = demo_data_dir.get_next()
		while demo_dir_name != "":
			if demo_data_dir.current_is_dir():
				
				var json_text = FileAccess.get_file_as_string(demo_path + "/" + demo_dir_name + "/info.json")
				var json_dict = JSON.parse_string(json_text)
				
				var demo_title: String = json_dict.title
				var demo_author: String = json_dict.author
				var demo_description: String = json_dict.description
				var exe_filepath: String = json_dict.exe_filepath
				
				var thumbnail: Texture2D = ImageTexture.create_from_image(Image.load_from_file(demo_path + "/" + demo_dir_name + "/thumbnail.png")) as Texture2D
				var has_played: bool = false
				if has_played_dict.has(demo_title):
					has_played = has_played_dict[demo_title]
				
				var demo_data: DemoData = DemoData.new(demo_title, demo_author, demo_description, exe_filepath, thumbnail, has_played)
				demo_data_array.push_back(demo_data)
				
			demo_dir_name = demo_data_dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	
func setup_demo_block_grid() -> void:
	for c in demo_block_grid.get_children():
		c.queue_free()
		
	for i in 16:#demo_data_array.size():
		var demo_block_inst: DemoBlock = demo_block_packed.instantiate() as DemoBlock
		demo_block_grid.add_child(demo_block_inst)
		var x: float = (i % 4) * block_offset
		var y: float = -floori(i / 4) * block_offset
		demo_block_inst.position = Vector3(x, y, 0.0)
		
		var dd: DemoData = null
		
		var idx: int = scroll_index + i
		
		if idx < demo_data_array.size():
			dd = demo_data_array[idx]
		
		demo_block_inst.selected.connect(func():
			on_demo_block_selected(dd)
		)
		demo_block_inst.hovered.connect(func():
			on_demo_block_hovered(dd)
		)
		if dd != null:
			demo_block_inst.set_thumbnail_image(dd.thumbnail)
			if dd.has_played == true:
				demo_block_inst.show_star()


func make_hidden() -> void:
	visible = false
	demo_title_label.visible = false
	demo_description_label.visible = false


func on_demo_block_selected(demo_data: DemoData) -> void:
	if demo_data == null: return
	
	has_played_dict[demo_data.title] = true
	
	var config = ConfigFile.new()
	for entry in has_played_dict:
		config.set_value(entry, "has_played", has_played_dict[entry])
	config.save("user://demo_data.cfg")
	
	# run exe
	var demo_exe_path: String = demo_path + "/" + demo_data.exe_filepath + ".exe"
	var demo_exe_dict: Dictionary = OS.execute_with_pipe(demo_exe_path, [])
	current_demo_pid = demo_exe_dict["pid"]
	
	App.instance.pause_audio()


func on_demo_block_hovered(demo_data: DemoData) -> void:
	if demo_data == null:
		demo_title_label.text = ""
		demo_author_label.text = ""
		demo_description_label.text = ""
		return
		
	demo_title_label.text = "Title: " + demo_data.title
	demo_author_label.text = "Author: " + demo_data.author
	demo_description_label.text = "Description: " + demo_data.description


func on_up_arrow_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
		scroll_index -= 4
		if scroll_index < 0:
			scroll_index = 0
			
		load_demo_data()
		setup_demo_block_grid()
		
		arrow_selected_sfx.play()
		
		
func on_up_arrow_mouse_entered() -> void:
	arrow_hovered_sfx.play()
	up_arrow_hovered = true
	
	
func on_up_arrow_mouse_exited() -> void:
	up_arrow_hovered = false
	
	
func on_down_arrow_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
		scroll_index += 4
		if scroll_index > demo_data_array.size():
			scroll_index -= 4
			
		load_demo_data()
		setup_demo_block_grid()
		
		arrow_selected_sfx.play()
		
		
func on_down_arrow_mouse_entered() -> void:
	arrow_hovered_sfx.play()
	down_arrow_hovered = true
	
	
func on_down_arrow_mouse_exited() -> void:
	down_arrow_hovered = false


func on_title_bar_home_button_pressed() -> void:
	demo_title_label.hide()
	demo_author_label.hide()
	demo_description_label.hide()
	animation_player.play("trans_out")
	await animation_player.animation_finished
	App.instance.change_scene_instant("main_menu")


func on_scroll_container_mouse_entered() -> void:
	is_hovering_info_scroll = true
	

func on_scroll_container_mouse_exited() -> void:
	is_hovering_info_scroll = false

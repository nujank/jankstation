class_name DemoBlock
extends StaticBody3D


signal hovered
signal selected


@export var hovered_sfx: AudioStream


@onready var background: MeshInstance3D = $Background
@onready var foreground: MeshInstance3D = $Foreground
@onready var wireframe: MeshInstance3D = $Wireframe
@onready var thumbnail: MeshInstance3D = $Thumbnail
@onready var star_mesh: MeshInstance3D = $StarMesh
@onready var beep_sfx: AudioStreamPlayer = $BeepSFX
@onready var selected_sfx: AudioStreamPlayer = $SelectedSFX


var ticks: float = 0.0
var is_hovered: bool = false


func _ready() -> void:
	thumbnail.material_override = thumbnail.material_override.duplicate()
	
	wireframe.mesh = MeshUtils.build_line_mesh(MeshUtils.generate_wireframe_box_mesh_data(Vector3.ONE), wireframe.material_override)
	ticks += get_index()
	
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	input_event.connect(on_input_event)
	
	
func _process(delta: float) -> void:	
	if is_hovered == true:
		scale = lerp(scale, Vector3(1.5, 1.5, 1.5), delta * 20)
		
		rotation.y = sin(ticks) * deg_to_rad(3.0)
		rotation.x = cos(ticks) * deg_to_rad(3.0)
		ticks += delta * 2
	else:
		
		scale = lerp(scale, Vector3(1.0, 1.0, 1.0), delta * 20)
		rotation.y = sin(ticks) * deg_to_rad(1.0)
		rotation.x = cos(ticks) * deg_to_rad(1.0)
		ticks += delta / 3.0


func set_thumbnail_image(image: Texture2D) -> void:
	thumbnail.visible = true
	thumbnail.material_override.albedo_texture = image
	
	
func show_thumbnail_image() -> void:
	thumbnail.show()
	
	
func hide_thumbnail_image() -> void:
	thumbnail.hide()
	
	
func show_star() -> void:
	star_mesh.show()
	
	
func hide_star() -> void:
	star_mesh.hide()


func on_mouse_entered() -> void:
	is_hovered = true
	
	#var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
	#audio_stream_player.stream = hovered_sfx
	#add_child(audio_stream_player)
	#audio_stream_player.finished.connect(func():
		#audio_stream_player.queue_free()
	#)
	#audio_stream_player.play()
	beep_sfx.play()
	hovered.emit()
	
	
func on_mouse_exited() -> void:
	#scale = Vector3.ONE
	is_hovered = false


func on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
		selected_sfx.play()
		selected.emit()

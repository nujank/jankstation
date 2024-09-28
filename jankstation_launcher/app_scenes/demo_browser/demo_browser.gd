class_name DemoBrowser
extends Node3D


@export var demo_block_packed: PackedScene

@onready var demo_block_grid: Node3D = $DemoBlockGrid
@onready var up_arrow_mesh: MeshInstance3D = $UpArrowMesh
@onready var down_arrow_mesh: MeshInstance3D = $DownArrowMesh
@onready var demo_title_label: RichTextLabel = $DemoTitleLabel
@onready var demo_description_label: RichTextLabel = $DemoDescriptionLabel
@onready var back_button: TextureButton = $BackButton

var block_offset: float = 1.5

func _ready() -> void:
	up_arrow_mesh.mesh = MeshUtils.build_line_mesh(MeshUtils.generate_triangle_mesh_data(0.35), up_arrow_mesh.material_override)
	down_arrow_mesh.mesh = MeshUtils.build_line_mesh(MeshUtils.generate_triangle_mesh_data(0.35), down_arrow_mesh.material_override)
	
	setup_demo_block_grid()
	
	back_button.pressed.connect(on_back_button_pressed)
	
	
func setup_demo_block_grid() -> void:
	for i in 16:
		var demo_block_inst: DemoBlock = demo_block_packed.instantiate() as DemoBlock
		demo_block_grid.add_child(demo_block_inst)
		var x: float = (i % 4) * block_offset
		var y: float = floori(i / 4) * block_offset
		demo_block_inst.global_position = Vector3(x, y, 0.0)


func make_hidden() -> void:
	visible = false
	demo_title_label.visible = false
	demo_description_label.visible = false


func on_back_button_pressed() -> void:
	App.instance.change_scene_instant("main_menu")

class_name Main
extends Node3D


@export var demo_block_packed: PackedScene

@onready var background_grid: MeshInstance3D = $Camera3D/BackgroundGrid
@onready var demo_block_grid: Node3D = $DemoBlockGrid
@onready var up_arrow_mesh: MeshInstance3D = $UpArrowMesh
@onready var down_arrow_mesh: MeshInstance3D = $DownArrowMesh

var offset: float = 1.5

func _ready() -> void:
	background_grid.mesh = MeshUtils.build_wireframe_grid_mesh(32, background_grid.material_override)
	
	up_arrow_mesh.mesh = MeshUtils.build_line_mesh(MeshUtils.generate_triangle_mesh_data(0.35), up_arrow_mesh.material_override)
	down_arrow_mesh.mesh = MeshUtils.build_line_mesh(MeshUtils.generate_triangle_mesh_data(0.35), down_arrow_mesh.material_override)
	
	setup_demo_block_grid()
	
	
func setup_demo_block_grid() -> void:
	for i in 16:
		var demo_block_inst: DemoBlock = demo_block_packed.instantiate() as DemoBlock
		demo_block_grid.add_child(demo_block_inst)
		var x: float = (i % 4) * offset
		var y: float = floori(i / 4) * offset
		demo_block_inst.global_position = Vector3(x, y, 0.0)

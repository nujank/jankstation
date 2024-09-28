class_name MainMenu
extends Node3D


@onready var demo_browser_button: Button = $VBoxContainer/DemoBrowserButton
@onready var config_button: Button = $VBoxContainer/ConfigButton
@onready var exit_button: Button = $VBoxContainer/ExitButton


#var points: Array[Vector3] = []
#var velocities: Array[Vector3]  = []
#
#@export var point_material: StandardMaterial3D
#var point_mesh: ImmediateMesh = null
#@export var point_line_material: StandardMaterial3D
#var point_line_mesh: ImmediateMesh = null


func _ready() -> void:
	demo_browser_button.pressed.connect(on_demo_browser_button_pressed)
	config_button.pressed.connect(on_config_button_pressed)
	exit_button.pressed.connect(on_exit_button_pressed)
	
	#var point_mesh_inst: MeshInstance3D = MeshInstance3D.new()
	#point_mesh = ImmediateMesh.new()
	#point_mesh_inst.mesh = point_mesh
	#point_mesh_inst.cast_shadow = MeshInstance3D.SHADOW_CASTING_SETTING_OFF
	#point_mesh_inst.name = "PointMesh"
	#add_child(point_mesh_inst)
	#
	#var point_line_mesh_inst: MeshInstance3D = MeshInstance3D.new()
	#point_line_mesh = ImmediateMesh.new()
	#point_line_mesh_inst.mesh = point_line_mesh
	#point_line_mesh_inst.cast_shadow = MeshInstance3D.SHADOW_CASTING_SETTING_OFF
	#point_line_mesh_inst.name = "PointLineMesh"
	#add_child(point_line_mesh_inst)
	#
	#for i in 10:
		#var rx: float = randf_range(-2.0, 2.0)
		#var ry: float = randf_range(-2.0, 2.0)
		#var rz: float = randf_range(-2.0, 2.0)
		#points.push_back(Vector3(2.5 + rx, 2.5 + ry, rz))
		#
		#var vx: float = randf_range(-1.0, 1.0)
		#var vy: float = randf_range(-1.0, 1.0)
		#var vz: float = randf_range(-1.0, 1.0)
		#velocities.push_back(Vector3(vx, vy, vz))
		
	
#func _process(delta: float) -> void:
	#for i in points.size():
		#var p: Vector3 = points[i]
		#p += velocities[i] * delta
		#
		#var dir: Vector3 = p.direction_to(Vector3(3, 2.5, 0.0))
		#velocities[i] += dir * delta
		#
		#points[i] = p
	#
	#point_mesh.clear_surfaces()
	#point_mesh.surface_begin(Mesh.PRIMITIVE_POINTS, point_material)
	#
	#point_line_mesh.clear_surfaces()
	#point_line_mesh.surface_begin(Mesh.PRIMITIVE_LINES, point_line_material)
	#
	#var did_create_surface: bool = false
	#for p in points:
		#point_mesh.surface_add_vertex(p)
		#for other in points:
			#if p == null || other == null:
				#continue
			#if p == other:
				#continue
				#
			#var dist: float = p.distance_to(other)
			#if dist < 1.5:
				#point_line_mesh.surface_add_vertex(p)
				#point_line_mesh.surface_add_vertex(other)
				#did_create_surface = true
	#if did_create_surface == true:
		#point_line_mesh.surface_end()
	#point_mesh.surface_end()


func on_demo_browser_button_pressed() -> void:
	App.instance.change_scene_instant("demo_browser")
	
	
func on_config_button_pressed() -> void:
	pass
	
	
func on_exit_button_pressed() -> void:
	get_tree().quit()

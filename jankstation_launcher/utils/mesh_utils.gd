class_name MeshUtils
extends Node


static func build_line_mesh(mesh_data: MeshData, material: StandardMaterial3D) -> ImmediateMesh:
	var immediate_mesh: ImmediateMesh = ImmediateMesh.new()
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
		
	var idx: int = 0
	while idx <= mesh_data.edges.size() - 1:
		var p1: Vector3 = Vector3(mesh_data.vertices[mesh_data.edges[idx]])
		var p2: Vector3 = Vector3(mesh_data.vertices[mesh_data.edges[idx + 1]])
		immediate_mesh.surface_add_vertex(p1)
		immediate_mesh.surface_add_vertex(p2)
		idx += 2
	
	immediate_mesh.surface_end()
	
	return immediate_mesh


static func generate_wireframe_box_mesh_data(size: Vector3) -> MeshData:
	
	var mesh_data: MeshData = MeshData.new()
	
	var half_size_x: float = size.x / 2.0
	var half_size_y: float = size.y / 2.0
	var half_size_z: float = size.z / 2.0
	
	mesh_data.vertices.push_back(Vector3(-half_size_x, half_size_y, -half_size_z))
	mesh_data.vertices.push_back(Vector3(half_size_x, half_size_y, -half_size_z))
	mesh_data.vertices.push_back(Vector3(half_size_x, half_size_y, half_size_z))
	mesh_data.vertices.push_back(Vector3(-half_size_x, half_size_y, half_size_z))
	
	mesh_data.vertices.push_back(Vector3(-half_size_x, -half_size_y, -half_size_z))
	mesh_data.vertices.push_back(Vector3(half_size_x, -half_size_y, -half_size_z))
	mesh_data.vertices.push_back(Vector3(half_size_x, -half_size_y, half_size_z))
	mesh_data.vertices.push_back(Vector3(-half_size_x, -half_size_y, half_size_z))
	
	mesh_data.edges.push_back(0)
	mesh_data.edges.push_back(1)
	mesh_data.edges.push_back(1)
	mesh_data.edges.push_back(2)
	mesh_data.edges.push_back(2)
	mesh_data.edges.push_back(3)
	mesh_data.edges.push_back(3)
	mesh_data.edges.push_back(0)
	
	mesh_data.edges.push_back(4)
	mesh_data.edges.push_back(5)
	mesh_data.edges.push_back(5)
	mesh_data.edges.push_back(6)
	mesh_data.edges.push_back(6)
	mesh_data.edges.push_back(7)
	mesh_data.edges.push_back(7)
	mesh_data.edges.push_back(4)
	
	mesh_data.edges.push_back(0)
	mesh_data.edges.push_back(4)
	mesh_data.edges.push_back(1)
	mesh_data.edges.push_back(5)
	mesh_data.edges.push_back(2)
	mesh_data.edges.push_back(6)
	mesh_data.edges.push_back(3)
	mesh_data.edges.push_back(7)
	
	return mesh_data
	
	
static func build_wireframe_grid_mesh(size: int, material: StandardMaterial3D) -> ImmediateMesh:
	var immediate_mesh: ImmediateMesh = ImmediateMesh.new()
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	for i in size:
		immediate_mesh.surface_add_vertex(Vector3(-(size/2) + i, -(size/2), 0.0))
		immediate_mesh.surface_add_vertex(Vector3(-(size/2) + i, (size/2), 0.0))
		
		immediate_mesh.surface_add_vertex(Vector3(-(size/2), -(size/2) + i, 0.0))
		immediate_mesh.surface_add_vertex(Vector3((size/2), -(size/2) + i, 0.0))
		
	immediate_mesh.surface_end()
	
	return immediate_mesh


static func generate_triangle_mesh_data(size: float) -> MeshData:	
	var mesh_data: MeshData = MeshData.new()
	
	mesh_data.vertices.push_back(Vector3(-size, 0.0, 0.0))
	mesh_data.vertices.push_back(Vector3(size, 0.0, 0.0))
	mesh_data.vertices.push_back(Vector3(0.0, size, 0.0))
	
	mesh_data.edges.push_back(0)
	mesh_data.edges.push_back(1)
	
	mesh_data.edges.push_back(1)
	mesh_data.edges.push_back(2)
	
	mesh_data.edges.push_back(2)
	mesh_data.edges.push_back(0)
	
	return mesh_data

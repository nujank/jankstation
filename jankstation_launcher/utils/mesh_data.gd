class_name MeshData
extends RefCounted


var vertices: Array[Vector3] = []
var edges: Array[int] = []


func _init() -> void:
	vertices = []
	edges = []


func append_data(mesh_data: MeshData) -> void:
	vertices.append(mesh_data.vertices)
	edges.append(mesh_data.edges)

extends Node




# TODO: I copied this code for potential use. Delete or use.
#func square(pos: Vector3, size: Vector2, color = Color.WHITE_SMOKE, persist_ms = 0):
	#var mesh_instance := MeshInstance3D.new()
	#var box_mesh := BoxMesh.new()
	#var material := ORMMaterial3D.new()
#
	#mesh_instance.mesh = box_mesh
	#mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	#mesh_instance.position = pos
#
	#box_mesh.size = Vector3(size.x, size.y, 1)
	#box_mesh.material = material
#
	#material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	#material.albedo_color = color
#
	#return await final_cleanup(mesh_instance, persist_ms)
#
## 1 -> Lasts ONLY for current physics frame
## >1 -> Lasts X time duration.
## <1 -> Stays indefinitely
#func final_cleanup(mesh_instance: MeshInstance3D, persist_ms: float):
	#get_tree().get_root().add_child(mesh_instance)
	#if persist_ms == 1:
		#await get_tree().physics_frame
		#mesh_instance.queue_free()
	#elif persist_ms > 0:
		#await get_tree().create_timer(persist_ms).timeout
		#mesh_instance.queue_free()
	#else:
		#return mesh_instance

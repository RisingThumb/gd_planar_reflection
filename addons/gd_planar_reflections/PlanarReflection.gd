extends MeshInstance3D
class_name PlanarReflector

var materialToSet:ShaderMaterial = load("res://func_godot/entities/Func_planar_reflections/PlanarReflections/ReflectionMaterial.tres");

var reflect_camera : Camera3D
var reflect_viewport: SubViewport

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Test")
	reflect_viewport = SubViewport.new();
	add_child(reflect_viewport);
	reflect_viewport.size = Vector2i(1920,1080);
	
	reflect_camera = Camera3D.new();
	reflect_viewport.add_child(reflect_camera);
	reflect_camera.cull_mask = 1;
	reflect_camera.current = true;
	self.mesh.surface_set_material(0, materialToSet);
	
	reflect_camera.make_current();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_viewport()
	var main_cam: Camera3D = null
	if (Globals && Globals.player):
		main_cam = Globals.player.camera
	if (!main_cam):
		return

	
	
	var reflection_transform = global_transform * Transform3D().rotated(Vector3.RIGHT, PI/2);
	var plane_origin = reflection_transform.origin;
	var plane_normal = reflection_transform.basis.z.normalized();
	var reflection_plane = Plane(plane_normal, plane_origin.dot(plane_normal))
	
	var cam_pos = main_cam.global_transform.origin
	
	var proj_pos := reflection_plane.project(cam_pos)
	var mirrored_pos = cam_pos + (proj_pos - cam_pos) * 2.0
	
	reflect_camera.global_transform.origin = mirrored_pos

	reflect_camera.basis = Basis(
		main_cam.basis.x.normalized().bounce(reflection_plane.normal).normalized(),
		main_cam.basis.y.normalized().bounce(reflection_plane.normal).normalized(),
		main_cam.basis.z.normalized().bounce(reflection_plane.normal).normalized()
	)
	
	var mat:ShaderMaterial = self.mesh.surface_get_material(0)
	mat.set_shader_parameter("reflection_screen_texture", reflect_viewport.get_texture());

func update_viewport() -> void:
	reflect_viewport.size = get_viewport().size

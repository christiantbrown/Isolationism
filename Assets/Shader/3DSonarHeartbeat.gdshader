shader_type spatial;
render_mode unshaded;

varying mat4 cam; //what is this

uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D screen_depth : hint_depth_texture;
void vertex(){
	POSITION = vec4(UV *2.0 - 1.0, 0.0, 1.0);
	cam = INV_VIEW_MATRIX;
}

void fragment() {
	// Place fragment code here.
	vec4 ogPixel = texture(screen_texture, SCREEN_UV);
	
	//literally copied from godot.com
	float depth = texture(screen_depth, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	
	//yeah i have no clue what this is doing
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	//huh, below somehow fully reconstructs world points, but luckily we dont need that
	//vec4 world = cam * INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	//vec3 world_position = world.xyz / world.w;
	
	ALBEDO = vec3(1.0 / linear_depth);
}

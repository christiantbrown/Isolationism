shader_type canvas_item;
uniform float cutOff;
//render_mode unshaded;
void fragment() {
	vec2 sdfPoint = screen_uv_to_sdf(SCREEN_UV);
	float sdfReturn = texture_sdf(vec2((1.0 / SCREEN_PIXEL_SIZE.x) * UV.x, (1.0 / SCREEN_PIXEL_SIZE.y) * UV.y));
	float adjuster = sdfReturn / cutOff;
	if(adjuster > 1.0){
		adjuster = 0.0;
	}
	//(1.0 / SCREEN_PIXEL_SIZE.x) this gives you the display size of the screen, so the entire game window
	//COLOR.rgb = vec3(sdfReturn < 100.0 ? 1.0 : 0.0); 
	//COLOR.rgb =vec3(adjuster, adjuster, 0.0);
	if(sdfReturn < 1.0){
		COLOR.rgb = vec3(0.0);
	}
	else{
		COLOR.rgb = vec3(1.0);
	}
	//COLOR.b = (1.0 / SCREEN_PIXEL_SIZE.x) > 2400.0 ? 0.5 : 0.0;
	
	//sdf return is less than one inside objects
	COLOR.a = 1.0;
}

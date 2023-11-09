shader_type canvas_item;

uniform sampler2D myViewport;


void fragment() {
	// Place fragment code here.
	//this is just a shader to check if the normal map is working for now, in the future this shader will be what the overlay is
	ivec2 texPos = ivec2(int((1.0 / SCREEN_PIXEL_SIZE.x) * UV.x), int((1.0 / SCREEN_PIXEL_SIZE.y) * UV.y));
	vec4 pixel = texelFetch(myViewport, texPos, 0);
	COLOR = pixel.a == 1.0 ? vec4(1.0) : pixel ;
	//COLOR = vec4(float(texPos.y) * SCREEN_PIXEL_SIZE.y);
	
}

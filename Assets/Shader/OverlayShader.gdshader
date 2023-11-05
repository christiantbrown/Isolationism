shader_type canvas_item;

uniform sampler2D myViewport;

uniform float objectColor;

uniform vec4 displayTestTrue;
uniform vec4 displayTestFalse;

void fragment() {
	// Place fragment code here.
	//this is just a shader to check if the normal map is working for now, in the future this shader will be what the overlay is
	ivec2 texPos = ivec2(int((1.0 / SCREEN_PIXEL_SIZE.x) * UV.x), int((1.0 / SCREEN_PIXEL_SIZE.y) * UV.y));
	vec4 pixel = texelFetch(myViewport, texPos, 0);
	COLOR = (pixel.b == objectColor || pixel.g == objectColor || pixel.g == objectColor) ? displayTestTrue : displayTestFalse;
	
}

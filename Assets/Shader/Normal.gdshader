shader_type canvas_item;
//uniform are adjustable in the editor
uniform sampler2D myArray;
uniform vec4 object;
uniform vec4 background;

//set this to whatever the null background color will be, right now it is 76
const float noColorBackground = (76.0 / 255.0);

//hints allow us to predefined variables, like the screen texture
uniform sampler2D screen_texture : hint_screen_texture;

void vertex(){

}

void fragment() {
	//this converts the uv position to the pixel position
	ivec2 texPos = ivec2(int((1.0 / SCREEN_PIXEL_SIZE.x) * UV.x), int((1.0 / SCREEN_PIXEL_SIZE.y) * UV.y));
	//this is the actual pixel color below, using the pixel position to grab from our texture stored in myArray
	vec4 pixel = texelFetch(myArray, texPos, 0);
	//we then check the texture for null color, which for now is the background color of the editor, which we can change if it is a color we want to use
	//but the color is set to black if the null color is found, and white if any other is found, so we create a texture map where all objects are colored white
	// and nothing is colored black, which we can use to apply shaders to certain objects, like for the heartbeat mechanic, or for lighting
	//oh also the camera doesnt render anything that is not in its cull list, notes on that in NormalMap.txt
	COLOR = (pixel.b == noColorBackground && pixel.g == noColorBackground && pixel.g == noColorBackground) ? background : object;

}

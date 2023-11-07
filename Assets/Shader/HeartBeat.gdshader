shader_type canvas_item;
uniform vec2 playerPos;
uniform float radius;
const int maxStep = 32;

void fragment() {
	//below retrieves current pixel position
	COLOR = vec4(0.0);
	ivec2 texPos = ivec2(int((1.0 / SCREEN_PIXEL_SIZE.x) * UV.x), int((1.0 / SCREEN_PIXEL_SIZE.y) * UV.y));
	//distance between player and current pixel
	vec2 tPvector = vec2(texPos) - playerPos;
	if(tPvector.x * tPvector.x + tPvector.y * tPvector.y < radius * radius)
	{
		float sdfReturn = texture_sdf(vec2((1.0 / SCREEN_PIXEL_SIZE.x) * UV.x, (1.0 / SCREEN_PIXEL_SIZE.y) * UV.y));
		if(sdfReturn < 0.0 || texture_sdf(playerPos) < 0.0){//this means the point is inside an occluder
			COLOR = vec4(1.0, 0.0, 0.0, 1.0);
		}
		else{// point is outside occluder test for it
			COLOR = vec4(1.0, 1.0, 0.0, 1.0);
			float sdfReturn = texture_sdf(vec2(texPos));
			vec2 vector = (playerPos - vec2(texPos));
			vector = normalize(vector);
			vec2 curPos = vec2(texPos);
			int i = 0;
			float lengthToCenter = length(playerPos - curPos);
			while(i < maxStep){
				curPos += vector * max(min(sdfReturn, lengthToCenter), .1);// this number defines how slow the rays will go inside the objects, so the less speed they have the less get through the occluders
				lengthToCenter = length(playerPos - curPos);
				if(lengthToCenter < .25){//found the center, close as .25 pixel
					i = maxStep;
					COLOR = vec4(0.0, 0.0, 0.0, 1.0);
				}
				sdfReturn = texture_sdf(curPos);
				if(sdfReturn < -5.0){// this number decides how close the pixels will get to the occluders, larger the closer, but also the larger the less colors are set by the while loop
					i = maxStep;
					COLOR = vec4(1.0);
				}
				++i;
				}
		}
		//COLOR = vec4(1.0);
	}
	
	// Place fragment code here.
}

shader_type canvas_item;
uniform vec2 playerPos;
uniform float radius;
uniform sampler2D objectMap;
uniform vec4 objectColor;
uniform vec4 darkNessColor;
const int maxStep = 32;

//these values seem to work pretty well for the raycast, play around with them to find better if you want though
const float minStepD = .5;
const float hitTargetD = .25;
const float insideOccluder = -2.0;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;


void fragment() {
	//below retrieves current pixel position
	vec2 texPos = vec2((1.0 / SCREEN_PIXEL_SIZE.x) * UV.x, (1.0 / SCREEN_PIXEL_SIZE.y) * UV.y);
	//distance between player and current pixel, which is also used to find the direction for the raycast
	vec2 vector = (playerPos - texPos);
	if(vector.x * vector.x + vector.y * vector.y < radius * radius)
	{
		bool foundInside =false;
		
		//retrieves color of object map, testing to see if it is 
		float pixelObjectColor = texelFetch(objectMap, ivec2(texPos), 0).x == 1.0 ? 1.0 : 0.0;
		
		//signed distance float, to find the distance from the nearest occluder
		float sdfReturn = texture_sdf(texPos);
		if(sdfReturn < 0.0 || texture_sdf(playerPos) < 0.0){//this means the point is inside an occluder
			//un comment all Color assignments and comment all actually used ones to see pixel values
			
			//COLOR = vec4(1.0, 0.0, 0.0, 1.0);//red
		}
		else{// point is outside occluder test for it
			//COLOR = vec4(1.0, 1.0, 0.0, 1.0);//yellow this color is assigned if the point is near and tracing along an edge, because it is constantly in a vector field of near 0, but it needs to keep on going from that point

			vector = normalize(vector);
			int i = 0;
			float lengthToCenter = length(playerPos - texPos);
			//adds max distance we can, then checks if hit target, if not retrieve signeddistance again, check if inside occluder, if not loop
			while(i < maxStep){
				texPos += vector * max(min(sdfReturn, lengthToCenter), minStepD);// this number defines how slow the rays will go inside the objects, so the less speed they have the less get through the occluders
				lengthToCenter = length(playerPos - texPos);
				if(lengthToCenter < hitTargetD){//found the center, close as hittarget
					i = maxStep;
					//COLOR = vec4(0.0, 0.0, 0.0, 1.0);//black
					foundInside = true;
				}
				sdfReturn = texture_sdf(texPos);
				if(sdfReturn < insideOccluder){//point is inside occluder, with a error check value of insideOccluder
					i = maxStep;
					//COLOR = vec4(1.0);//white
				}
				++i;
			}
		}
		if(foundInside){//need to move this outside to make it cover whole screen (both the if and else statement)
			
			COLOR = texture(SCREEN_TEXTURE, SCREEN_UV) * (objectColor * pixelObjectColor);
			//COLOR = vec4(1.0);

		}
		else{
			COLOR *= darkNessColor;
		}
		
	}
	
	// Place fragment code here.
}

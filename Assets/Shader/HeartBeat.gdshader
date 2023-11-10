shader_type canvas_item;
uniform vec2 playerPos;
uniform float radius;
uniform sampler2D objectMap;
uniform float objectIntensity;
uniform vec4 objectColor;
uniform float darknessIntesity;//linear interpolation between darkness and light, closer to one more dark shade, closer to 0 more light
uniform vec4 darkNessColor;
uniform float hBOCDistance;//this is the outline for the heartbeat "circle" it starts at the edge of the radius and goes 
uniform float hBOCIntensity;
uniform vec4 heartBeatOutlineColor;
const int maxStep = 32;

uniform float heartbeat = 0; //this is obviosuly the heartbeat

//these values seem to work pretty well for the raycast, play around with them to find better if you want though
const float minStepD = .5;
const float hitTargetD = .25;
const float insideOccluder = -2.0;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;


void fragment() {
	//below retrieves current pixel position
	vec2 texPos = vec2((1.0 / SCREEN_PIXEL_SIZE.x) * UV.x, (1.0 / SCREEN_PIXEL_SIZE.y) * UV.y);
	ivec2 savedTexPos = ivec2(texPos);
	//distance between player and current pixel, which is also used to find the direction for the raycast
	vec2 vector = (playerPos - texPos);
	int foundInside = 1; 
	float playerDistance;
	if(vector.x * vector.x + vector.y * vector.y < radius * heartbeat * radius * heartbeat)
	{
		foundInside += 2;
		//retrieves color of object map, testing to see if it is 
		
		//signed distance float, to find the distance from the nearest occluder
		float sdfReturn = texture_sdf(texPos);
		if(sdfReturn < 0.0 ||texture_sdf(playerPos) < 0.0)//this means the point is inside an occluder or the player is inside an occluder, oh no
		{
			//un comment all Color assignments and comment all actually used ones to see pixel values
			
			//COLOR = vec4(1.0, 0.0, 0.0, 1.0);//red
			//point is actualy inside occluder
		}
		else
		{// point is outside occluder test for it
			//COLOR = vec4(1.0, 1.0, 0.0, 1.0);//yellow this color is assigned if the point is near and tracing along an edge, because it is constantly in a vector field of near 0, but it needs to keep on going from that point

			vector = normalize(vector);
			int i = 0;
			float lengthToCenter = length(playerPos - texPos);
			playerDistance = lengthToCenter;
			//adds max distance we can, then checks if hit target, if not retrieve signeddistance again, check if inside occluder, if not loop
			while(i < maxStep)
			{
				texPos += vector * max(min(sdfReturn, lengthToCenter), minStepD);// this number defines how slow the rays will go inside the objects, so the less speed they have the less get through the occluders
				lengthToCenter = length(playerPos - texPos);
				if(lengthToCenter < hitTargetD)
				{//found the center, close as hittarget
					i = maxStep;
					--foundInside; 
					//COLOR = vec4(0.0, 0.0, 0.0, 1.0);//black
				}
				sdfReturn = texture_sdf(texPos);
				if(sdfReturn < insideOccluder)
				{//point is inside occluder, with a error check value of insideOccluder
					i = maxStep; 
					//COLOR = vec4(1.0);//white
					//this occurs when the point is blocked by an occluder
				}
				++i;
			}
		}
		
	}
	vec4 buffer = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 basePixelColor = texture(SCREEN_TEXTURE, SCREEN_UV);
	if(foundInside > 1){//inside circle check for object to render
		ivec2 texPos2 = ivec2(int((1.0 / SCREEN_PIXEL_SIZE.x) * UV.x), int((1.0 / SCREEN_PIXEL_SIZE.y) * UV.y));
		vec4 pixel = texelFetch(objectMap, texPos2, 0);
		buffer = texelFetch(objectMap, texPos2, 0);
		//screen texture alpha channel is never zero, so you can't test for that, instead you need to see if its equal to the base color, which is this
		if(pixel.a == 1.0 && pixel.b != 0.0){
			//basePixelColor = mix(buffer, objectColor, 2.0);
			basePixelColor = mix(pixel, objectColor, objectIntensity);
		}

		//basePixelColor = buffer;
		
		if(foundInside % 2 == 0)
			{
				if((playerDistance < radius * heartbeat && playerDistance > radius * heartbeat - hBOCDistance)  || (texture_sdf(vec2(texPos2)) < hBOCDistance))
				{
					//probably want to remove the texture sdf check, as it looks awful
					basePixelColor = mix(basePixelColor, heartBeatOutlineColor, hBOCIntensity);
				}
			}
	}
	COLOR = mix(basePixelColor, darkNessColor, float(foundInside % 2) * darknessIntesity);
	//COLOR = mix(basePixelColor, darkNessColor, 1.0);
	//basePixelColor = basePixelColor;
	//COLOR = mix(basePixelColor, darkNessColor, 0.0);
	if(basePixelColor.a != 1.0){//this checks if the alphachannel is bellow 1.0
		COLOR = vec4(basePixelColor.a);
	}
	//use mix to mix colors, do not multiply as then alpha channels cannot be adjusted, thus the multiplication looks pretty bad, I don't know what mix does but it works
	if(foundInside < 1){
		//COLOR = vec4(float(foundInside % 2));
	}
	
	
	
	// Place fragment code here.
}

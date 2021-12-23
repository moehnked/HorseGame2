shader_type spatial;

uniform float pivotRotAmount = 80.5;
uniform float time_scale = 1.0;

uniform vec3 colorMask = vec3(1.0,1.0,1.0); // eg. green
varying vec2 texCoord;
uniform sampler2D overlay;

uniform vec2 uvOffset = vec2(0.0,0.0);
uniform vec2 uvScale = vec2(0.0,0.0);


vec2 rotate(vec2 point, float degree, vec2 pivot)
{
    float radAngle = -radians(degree);// "-" - clockwise
    float x = point.x;
    float y = point.y;

    float rX = pivot.x + (x - pivot.x) * cos(radAngle) - (y - pivot.y) * sin(radAngle);
    float rY = pivot.y + (x - pivot.x) * sin(radAngle) + (y - pivot.y) * cos(radAngle);

    return vec2(rX, rY);
}

void vertex(){
	float time = TIME * time_scale;
	//VERTEX.x += cos(time) * side_to_side;
	float pivot_angle = cos(time) * 0.1 * pivotRotAmount;
	//mat2 rotation_matrix = mat2(vec2(cos(pivot_angle), -sin(pivot_angle)), vec2(sin(pivot_angle), cos(pivot_angle)));
	VERTEX.x = rotate(VERTEX.xy,pivot_angle,vec2(0.0,-1.0)).x;
}

void fragment(){
	vec4 tex = texture(overlay, (UV * uvScale) + uvOffset);
    ALBEDO = tex.rgb;
	ALPHA = tex.a;
}

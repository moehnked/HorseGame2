shader_type spatial;

uniform float apha = 0.3;
uniform float scale = 0.01;

void fragment(){
	float t = TIME;
	vec2 r = vec2(1,1);
	vec3 c;
	float l,z=t;
	for(int i=0;i<3;i++) {
		vec2 uv,p=UV.xy/r;
		uv=p;
		p-=.5;
		p.x*=r.x/r.y;
		l=length(p) * apha;
		uv+=p/l*(sin(z)+4.)*abs(sin(l*27.-z-z));
		float val = scale/length(mod(uv,1.)-.5);
		c.x = val;
		c.y = val;
		c.z = val;
	}
	ALBEDO=vec3(c/l);
	//ALPHA = 1.0;
	ALPHA = -abs(sin(t* 0.2));
}
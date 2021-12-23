shader_type canvas_item;

uniform float apha = .3;

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
		z+=.07;
		l=length(p) * apha;
		uv+=p/l*(sin(z)+4.)*abs(sin(l*27.-z-z));
		float val = .01/length(mod(uv,1.)-.5);
		c.x = val;
		c.y = val;
		c.z = val;
	}
	COLOR=vec4(c/l,t);
}
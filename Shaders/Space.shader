shader_type spatial;

const int iterations = 17;
const float formuparam = 0.53;

const int volsteps = 20;
const float stepsize = 0.1;

const float zoom = 50.01;
const float tile = 0.250;
const float speed = 0.00002;

const float brightness = 0.001;
const float darkmatter = 1.9500;
const float distfading = 0.730;
const float saturation = 0.950;
const vec2 projectResolution = vec2(1024,600);
uniform float finalAlpha = 1.0;

void mainVR( out vec4 fragColor, in vec2 fragCoord, in vec3 ro, in vec3 rd )
{
	//get coords and direction
	vec3 dir=rd;
	vec3 from=ro;
	
	//volumetric rendering
	float s=0.1,fade=1.;
	vec3 v=vec3(0.);
	for (int r=0; r<volsteps; r++) {
		vec3 p=from+s*dir*.5;
		p = abs(vec3(tile)-mod(p,vec3(tile*2.))); // tiling fold
		float pa,a=pa=0.;
		for (int i=0; i<iterations; i++) { 
			p=abs(p)/dot(p,p)-formuparam; // the magic formula
			a+=abs(length(p)-pa); // absolute sum of average change
			pa=length(p);
		}
		float dm=max(0.,darkmatter-a*a*.001); //dark matter
		a*=a*a; // add contrast
		if (r>6) fade*=1.-dm; // dark matter, don't render near
		//v+=vec3(dm,dm*.5,0.);
		v+=fade;
		v+=vec3(s,s*s,s*s*s*s)*a*brightness*fade; // coloring based on distance
		fade*=distfading; // distance fading
		s+=stepsize;
	}
	v=mix(vec3(length(v)),v,saturation); //color adjust
	fragColor = vec4(v*.01,1.);	
}

void fragment()
{
	
	//get coords and direction
	vec4 fragColor = COLOR;
	vec2 uv=UV.xy/projectResolution.xy-.5;
	uv.y*=projectResolution.y/projectResolution.x;
	vec3 dir=vec3(uv*zoom,1.);
	float time=TIME*speed+.25;

	//mouse rotation
	float a1=.5+projectResolution.x/projectResolution.x*2.;
	float a2=.8+projectResolution.y/projectResolution.y*2.;
	mat2 rot1=mat2(vec2(cos(a1),sin(a1)),vec2(-sin(a1),cos(a1)));
	mat2 rot2=mat2(vec2(cos(a2),sin(a2)),vec2(-sin(a2),cos(a2)));
	dir.xz*=rot1;
	dir.xy*=rot2;
	vec3 from=vec3(1.,.5,0.5);
	from+=vec3(time*2.,time,-2.);
	from.xz*=rot1;
	from.xy*=rot2;
	
	mainVR(fragColor, uv, from, dir);
	ALBEDO = fragColor.rgb + -vec3(0.15,0.05,-0.01);
	//ALPHA = fragColor.a;
	ALPHA = finalAlpha;
}
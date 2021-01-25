shader_type canvas_item;

uniform float FORCE = .2;
uniform float INIT_SPEED = 10.;
uniform float AMOUNT = 0.5;
uniform vec3 WATER_COL = vec3(18,140,200);
uniform float TIME_SCALE = 0.2;

float rand(vec2 co) {
    return fract(sin(dot(co.xy , vec2(12.9898, 78.233))) * 43758.5453);
}

float bubbles( vec2 uv, float size, float speed, float timeOfst, float blur, float time)
{
    vec2 ruv = uv*size  + .05;
    vec2 id = ceil(ruv) + speed;
    float t = (time + timeOfst)*speed;

    ruv.y -= t * (rand(vec2(id.x))*0.5+.5)*.1;
    vec2 guv = fract(ruv) - 0.5;

    ruv = ceil(ruv);
    float g = length(guv);

    float v = rand(ruv)*0.5;
    v *= step(v, clamp(FORCE, .1, .3));

    float m = smoothstep(v,v - blur, g);

    v*=.85;
    m -= smoothstep(v,v- .1, g);

    g = length(guv - vec2(v*.35, v*.35));
    float hlSize = v*.75;
    m += smoothstep(hlSize, 0., g)*.75;

    return m;
}

void fragment()
{
	vec2 iResolution = vec2(1024,600);
	vec2 uv = UV;
	vec3 wc = WATER_COL/255.0;
	float am = AMOUNT * sin(TIME) + AMOUNT + 0.01;
	float bubbleOpacity = 0.4 * sin(TIME * TIME_SCALE) + 0.4;

    float m = 0.;

    float sizeFactor = iResolution.y / 10.;

    float fstep = .1/am;
    for(float i=-1.0; i<=0.; i+=fstep){
        vec2 iuv = UV + vec2(cos(UV.y*2. + i*20. + TIME*.5)*.1, 0.);
        float size = (i*.15+0.2) * sizeFactor + 10.;
        m += bubbles(iuv + vec2(i*.1, 0.), size, INIT_SPEED + i*5., i*10., .3 + i*.25, TIME) * abs(i);
    }

    //vec3 col = wc + m*.4;
    vec3 col = wc + m*bubbleOpacity;

    COLOR = vec4(col, 0.15);
}
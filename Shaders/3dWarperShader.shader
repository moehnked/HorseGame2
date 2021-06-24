shader_type spatial;
render_mode specular_schlick_ggx;

uniform sampler2D tex_frg_2;



void vertex() {
// Output:0

}

void fragment() {
// Input:3
	vec3 n_out3p0 = vec3(UV, 0.0);

// VectorDecompose:9
	float n_out9p0 = n_out3p0.x;
	float n_out9p1 = n_out3p0.y;
	float n_out9p2 = n_out3p0.z;

// Input:6
	float n_out6p0 = TIME;

// ScalarOp:12
	float n_in12p1 = 1.00000;
	float n_out12p0 = n_out6p0 * n_in12p1;

// ScalarFunc:7
	float n_out7p0 = cos(n_out12p0);

// ScalarOp:13
	float n_in13p1 = 0.01700;
	float n_out13p0 = n_out7p0 * n_in13p1;

// ScalarOp:4
	float n_out4p0 = n_out9p0 + n_out13p0;

// ScalarFunc:8
	float n_out8p0 = sin(n_out12p0);

// ScalarOp:14
	float n_in14p1 = 0.06500;
	float n_out14p0 = n_out8p0 * n_in14p1;

// ScalarOp:11
	float n_out11p0 = n_out9p1 + n_out14p0;

// VectorCompose:10
	float n_in10p2 = 0.10000;
	vec3 n_out10p0 = vec3(n_out4p0, n_out11p0, n_in10p2);

// Texture:2
	vec4 tex_frg_2_read = texture(tex_frg_2, n_out10p0.xy);
	vec3 n_out2p0 = tex_frg_2_read.rgb;
	float n_out2p1 = tex_frg_2_read.a;

// Output:0
	ALBEDO = n_out2p0;
	ALPHA = n_out2p1;

}

void light() {
// Output:0

}

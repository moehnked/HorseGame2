shader_type canvas_item;

void fragment(){
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(color.rgb, vec3(0.1,1,1).rgb, 1);
	COLOR = color;
}
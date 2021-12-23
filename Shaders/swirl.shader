/*
	渦巻シェーダー by あるる（きのもと 結衣） @arlez80
	Swirl Shader by Yui Kinomoto

	MIT License
*/
shader_type spatial;
render_mode unshaded;

uniform float guruguru_power = 10.0;
uniform float vacuum_power = 0.1;
uniform float radius : hint_range( 0.0, 1.0 ) = 0.8;
uniform vec4 albedo : hint_color = vec4( 0.5, 0.5, 0.5, 1.0 );

void fragment( )
{
	vec4 CENTER_VIEW = INV_CAMERA_MATRIX * vec4( WORLD_MATRIX[3].xyz, 1.0 );
	vec2 diff = ( normalize( -CENTER_VIEW ).xy - VIEW.xy ) * ( -CENTER_VIEW.z );
	float to_center = length( diff );

	float r = clamp( 1.0 - to_center / ( radius * 0.5 ), 0.0, 1.0 ) * guruguru_power;
	float c = cos( r );
	float s = sin( r );
	mat2 mat = mat2( vec2( c, s ), vec2( -s, c ) );

	ALBEDO = albedo.rgb * textureLod( SCREEN_TEXTURE, SCREEN_UV + ( diff * vacuum_power ) * mat, 0.0 ).rgb;
	ALPHA = albedo.a;
}

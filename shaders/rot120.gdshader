shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

vec3 rot120(vec3 c) {
	return vec3(c.b, c.r, c.g);
}

void fragment() {
	vec3 c = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	c = rot120(c);
	COLOR.rgb = c;
}
shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

// https://en.wikipedia.org/wiki/HSL_and_HSV#From_RGB
vec3 rgbtohsv(vec3 c) {
	float sixty = PI / 3.0;
	
	float xmx = max(c.r, max(c.g, c.b)); // V
	float xmn = min(c.r, min(c.g, c.b));
	float ch = xmx - xmn;
	float l = 0.5 * (xmx + xmn);
	
	float h = 0.0;
	if (ch == 0.0);
	else {
		if (xmx == c.r) h = sixty * mod( ((c.g - c.b) / ch), 6.0);
		if (xmx == c.g) h = sixty * ( ((c.b - c.r) / ch) + 2.0);
		if (xmx == c.b) h = sixty * ( ((c.r - c.g) / ch) + 4.0);
	}
	
	float s = 0.0;
	if (xmx != 0.0) s = ch / xmx;
	
	return vec3(h, s, xmx);
	
}

vec3 hsvtorgb(vec3 hsv) {
	float sixty = PI / 3.0;
	float hp = hsv.x / sixty;
	float ch = hsv.z * hsv.y;
	float x = ch * (1.0 - abs(mod(hp, 2.0) - 1.0));
	
	vec3 res = vec3(0, 0, 0);
	if (hp < 1.0) res = vec3(ch, x, 0);
	else if (hp < 2.0) res = vec3(x, ch, 0);
	else if (hp < 3.0) res = vec3(0, ch, x);
	else if (hp < 4.0) res = vec3(0, x, ch);
	else if (hp < 5.0) res = vec3(x, 0, ch);
	else res = vec3(ch, 0, x);
	
	float m = hsv.z - ch;
	return vec3(res.x + m, res.y + m, res.z + m);
}

void fragment() {
	vec3 c = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	vec3 hsv = rgbtohsv(c);
	hsv.r = mod(hsv.r + TIME, 2.0 * PI);
	COLOR.rgb = hsvtorgb(hsv);
}
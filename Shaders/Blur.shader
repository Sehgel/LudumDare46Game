shader_type canvas_item;

uniform float coeficient = 0.0; 
uniform float amount: hint_range(0.0, 5.0);

void fragment() {
	COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, amount * coeficient).rgb;
}
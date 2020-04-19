shader_type canvas_item;

uniform float coeficient = 0.0; 

void fragment(){
	COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb * (abs(sin(TIME)) * coeficient + 1.0 - coeficient);
}
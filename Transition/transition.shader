shader_type canvas_item;
render_mode unshaded;

uniform float cutoff : hint_range(0.0, 1.0);
uniform float smoothing : hint_range(0.0, 1.0);
uniform bool reversed = false;
uniform sampler2D mask : hint_albedo;

void fragment(){
	float value = texture(mask, UV).r;
	float cutoff2 = cutoff;
	float smoothing2 = smoothing;
	float alpha;
	
	if (reversed){
		alpha = smoothstep(value, value + smoothing, cutoff * (1.0 + smoothing));
	} else {
		alpha = smoothstep(cutoff, cutoff + smoothing, (value + smoothing) / (1.0 + smoothing));
	}
	
	
	
	COLOR = vec4(COLOR.rgb, alpha);
	
}
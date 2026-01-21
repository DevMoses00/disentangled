shader_type canvas_item;

// --- Parameters ---
uniform float jolt_strength_pixels : hint_range(0.0, 64.0) = 6.0;
uniform float jumps_per_second : hint_range(0.0, 10.0) = 3.0;
uniform float jitter_scale : hint_range(0.0, 1.0) = 1.0;
uniform float seed = 123.0;
uniform float soften : hint_range(0.0, 1.0) = 0.0;

// --- Random helpers ---
float rand1(float x) {
	return fract(sin(x) * 43758.5453123);
}

float rand2(vec2 v) {
	return fract(sin(dot(v, vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	vec2 uv = UV;
	float phase = floor(TIME * jumps_per_second);

	// generate stable random offsets per phase
	float rx = rand2(vec2(phase + seed, uv.x * 37.0));
	float ry = rand2(vec2(phase + seed + 19.0, uv.y * 91.0));

	// center around 0
	rx = (rx - 0.5) * 2.0;
	ry = (ry - 0.5) * 2.0;

	// pixel offset
	vec2 pixel_offset = vec2(rx, ry) * jolt_strength_pixels * jitter_scale;
	vec2 uv_offset = pixel_offset * TEXTURE_PIXEL_SIZE;

	vec4 col = texture(TEXTURE, uv + uv_offset);

	if (soften > 0.0) {
		col.rgb *= mix(1.0, 0.9, soften);
	}

	COLOR = col;
}


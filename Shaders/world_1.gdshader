shader_type canvas_item;

uniform float wave_speed = 1.0;
uniform float wave_scale = 30.0;
uniform float distortion_strength = 0.005;
uniform vec2 player_velocity = vec2(0.0);

void fragment() {
    vec2 uv = UV;

	float dynamic_speed = wave_speed + length(player_velocity) * 0.01;
	float wave = sin(uv.y * wave_scale + TIME * dynamic_speed);

    // React to horizontal velocity (scaled and clamped)
    float velocity_influence = clamp(player_velocity.x * 0.001, -0.01, 0.01);

    // Total horizontal offset
    uv.x += (wave * distortion_strength) + velocity_influence;
	// vertical offset
	uv.y += sin(uv.x * wave_scale + TIME * wave_speed * 0.8) * 0.002;



    COLOR = texture(TEXTURE, uv);
}

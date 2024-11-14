shader_type spatial;

uniform sampler2D noise_tex;
uniform vec4 color_start : source_color;
uniform vec4 color_end : source_color;

void fragment() {
    vec3 uv = vec3(FRAGCOORD.xy, TIME); 

    // Offset the noise coordinates based on object position
    uv.xy += NODE_POSITION_WORLD.xy * 0.1; // Adjust scale as needed

    float noise_value = texture(noise_tex, uv.xy).r;

    vec4 color = mix(color_start, color_end, noise_value);
    
    // Adjust transparency based on height or distance
    ALPHA = noise_value * (1.0 - length(NODE_POSITION_WORLD) * 0.1); // Optional: fades based on position
    ALBEDO = color.rgb;
}

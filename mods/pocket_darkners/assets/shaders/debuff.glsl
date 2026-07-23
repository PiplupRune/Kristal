extern vec4 tint_color; 
extern float intensity;  
extern float scroll_y;   

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 texcolor = Texel(texture, texture_coords);
    if (texcolor.a == 0.0) { return texcolor; } 
    vec3 tinted_base = mix(texcolor.rgb, tint_color.rgb * texcolor.rgb, intensity);
    float bands = 6.0;
    float phase = (texture_coords.y - scroll_y) * bands * 6.283185;
    
    float pattern = sin(phase);
    float line_pattern = smoothstep(0.70, 0.98, pattern);
    float line_alpha = line_pattern * 0.8 * (intensity / 0.7);
    vec3 final_rgb = mix(tinted_base, vec3(1.0), line_alpha);
    return vec4(final_rgb, texcolor.a * color.a);
}

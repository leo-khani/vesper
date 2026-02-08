shader_type canvas_item;

uniform vec4 color_1 : source_color = vec4(1.0, 0.2, 0.2, 1.0);
uniform vec4 color_2 : source_color = vec4(0.2, 1.0, 0.4, 1.0);
uniform vec4 color_3 : source_color = vec4(0.2, 0.4, 1.0, 1.0);

// Set these so they add up to 1.0 for 0 spacing
// Example: 0.33, 0.33, 0.34
uniform float w1 : hint_range(0.0, 1.0) = 0.333;
uniform float w2 : hint_range(0.0, 1.0) = 0.333;
uniform float w3 : hint_range(0.0, 1.0) = 0.334;

uniform float repeat_count : hint_range(1.0, 40.0) = 10.0;
uniform float speed : hint_range(0.0, 10.0) = 2.0;
uniform float slant : hint_range(-1.0, 1.0) = 0.3;

void fragment() {
    // 1. Calculate slanted and animated coordinates
    // We use fract to wrap the value between 0 and 1
    float pc = UV.x - (UV.y * slant);
    float progress = fract((pc * repeat_count) - (TIME * speed));
    
    // 2. Determine which color to show
    vec4 final_color;
    
    // Since w1+w2+w3 = 1.0, progress will always fall into one of these
    if (progress < w1) {
        final_color = color_1;
    } else if (progress < w1 + w2) {
        final_color = color_2;
    } else {
        final_color = color_3;
    }
    
    // 3. Final Output
    // Use texture alpha if you have a sprite/mask, otherwise use 1.0
    float mask = texture(TEXTURE, UV).a;
    COLOR = vec4(final_color.rgb, mask);
}
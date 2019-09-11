#version 330

uniform sampler2D screen;
uniform float time;

in vec2 v_uv;
out vec4 col;

void main() {
    vec2 uv = v_uv - 0.5;
    float z = sqrt(1.0 - uv.x * uv.x - uv.y * uv.y);
    float a = 1.0 / (z * tan(0.87));
    vec2 nuv = (uv*a) + 0.5;

    vec2 vlerp = smoothstep(0.0, 0.01, nuv.xy) * smoothstep(0.0, 0.01, 1.0 - nuv.xy);
    float lerp = vlerp.x * vlerp.y;

    vec4 cval = (1.0 - lerp) * vec4(0.004, 0.004, 0.005, 1.0) + lerp * texture(screen, nuv);

    float val1 = abs(sin(nuv.x * 640.0/2.0))/2.0 + 0.5;
    float val2 = abs(sin(nuv.x * 640.0/2.0 + 0.66*3.14))/2.0 + 0.5;
    float val3 = abs(sin(nuv.x * 640.0/2.0 + 1.33*3.14))/2.0 + 0.5;
    float val4 = fract(nuv.y * (480.0 / 2.0) / 3.0);
    col = ((smoothstep(0.0, 0.27, val4) * smoothstep(0.0, 0.27, 1.0 - val4)) * 0.5 + 0.5) * (vec4(val1, val2, val3, 1.0) * 0.5 + 0.5) * cval;
}
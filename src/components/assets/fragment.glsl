in vec2 vUv;
out vec4 fragColor;

uniform float uTime;

uniform sampler2D uTexture1;
uniform sampler2D uTexture2;
uniform float uDustOpacity;

uniform float uLightness;
uniform vec3 uColor;

uniform float uScale;
uniform bool uInvert;

uniform vec2 uMouse;
uniform float uMouseSize;
uniform float uMouseStrength;

float noise(vec2 p) {
    return smoothstep(-0.5, 0.9, sin(dot(p, vec2(555.0, -1444.0))) * sin(p.y * 1444.0)) - 0.4;
}

float fabric(vec2 p) {
    const mat2 m = mat2(1.6, 1.2, -1.2, 1.6);
    float f = 0.4 * noise(p);
    f += 0.3 * noise(m * p);
    f += 0.2 * noise(m * m * p);
    return f;
}

float silkPattern(vec2 uv, vec2 fragWidth, float time) {
    float uvSum = uv.x + uv.y;
    float base = sin(5.0 * (uvSum + cos(2.0 * uv.x + 5.0 * uv.y)) + sin(12.0 * uvSum) - time);
    return 0.7 + 0.3 * base * (0.5 * base + 1.0);
}

float silkDerivative(vec2 uv, float time) {
    float xy = uv.x + uv.y;
    float base = 5.0 * (1.0 - 2.0 * sin(2.0 * uv.x + 5.0 * uv.y)) + 12.0 * cos(12.0 * xy);
    return 0.005 * base * (sign(base) + 3.0);
}

void main() {
    vec2 fragWidth = fwidth(vUv);
    vec2 scaledUv = gl_FragCoord.xy * max(fragWidth.x, fragWidth.y) * uScale;

    scaledUv.y += 0.03 * sin(8.0 * scaledUv.x - uTime);

    vec2 normalizedMouse = gl_FragCoord.xy * 2.0 - 1.0;
    float mouseDist = smoothstep(uMouseSize, 0.0, distance(uMouse, normalizedMouse));
    scaledUv += (mouseDist * 2.0 - 1.0) * 0.02 * uMouseStrength;

    float silk = sqrt(silkPattern(scaledUv, fragWidth, uTime));
    float derivative = silkDerivative(scaledUv, uTime);

    scaledUv += silk * silk * 0.05;

    vec3 baseColor = vec3(silk) * uLightness;
    if (!uInvert) {
        baseColor *= pow(texture(uTexture1, vec2(vUv.x, scaledUv.y)).rgb, vec3(2.2));
    }

    baseColor += 0.7 * vec3(1.0, 0.83, 0.6) * derivative;
    baseColor *= 1.0 - max(0.0, 0.8 * derivative);
    baseColor = clamp(baseColor, 0.0, 1.0);

    if (uInvert) {
        baseColor = pow(baseColor, vec3(0.3) / uColor);
        baseColor = 1.0 - baseColor;
        baseColor += (1.0 - silk * silk) * texture(uTexture2, vec2(vUv.x, scaledUv.y)).rgb;
    } else {
        baseColor = pow(baseColor, vec3(0.52, 0.5, 0.4));
        baseColor += (1.0 - silk * silk) * uDustOpacity * texture(uTexture2, vec2(vUv.x, scaledUv.y)).rgb;
    }

    fragColor = vec4(baseColor, 1.0);
}

out vec2 vUv;
uniform float uTime;
uniform vec3 uResolution;

void main() {
    vUv = uv;

    gl_Position = vec4(position, 1);
}

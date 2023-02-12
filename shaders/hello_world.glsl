
uniform float width;
uniform float height;

vec2 iResolution=vec2(width,height);
out vec4 fragColor;
void main(){
    vec2 uv=gl_FragCoord.xy/iResolution.xy;
    
    fragColor=vec4(uv.x,uv.y,0.,1.);
}

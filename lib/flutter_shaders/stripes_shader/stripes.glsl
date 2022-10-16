uniform float u_time;
#define PI 3.14159265359
uniform float tiles;
uniform float speed;
uniform float direction;
uniform float warpScale;
uniform float warpTiling;

vec4 fragment(in vec2 uv,in vec2 fragCoord){
    // vec2 uv=gl_FragCoord.xy/u_resolution.xy;
    
    // float tiles=tiles;
    
    vec2 uv2=uv;
    
    uv2.x=mix(uv.x,uv.y,direction);
    uv2.y=mix(uv.y,1.-uv.x,direction);
    
    uv2.x+=sin(uv2.y*warpTiling*PI*2.)*warpScale+speed;//u_time/10.;
    uv2.x*=tiles;
    
    float st=floor(fract(uv2.x)+.5);
    
    vec3 color=mix(vec3(0.,.032,1.),vec3(1.,.003,.449),st);
    
    return vec4(color,1.);
}
uniform float u_time;
#define PI 3.14159265359
uniform float tiles;
uniform float speed;
uniform float direction;
uniform float warpScale;
uniform float warpTiling;
uniform vec3 color1;
uniform vec3 color2;

vec2 rotatePoint(vec2 pt,vec2 center,float angle){
    float sinAngle=sin(angle);
    float cosAngle=cos(angle);
    pt-=center;
    vec2 r=vec2(1.);
    r.x=pt.x*cosAngle-pt.y*sinAngle;
    r.y=pt.x*sinAngle+pt.y*cosAngle;
    r+=center;
    return r;
}

vec4 fragment(in vec2 uv,in vec2 fragCoord){
    // vec2 uv=gl_FragCoord.xy/u_resolution.xy;
    
    // float tiles=tiles;
    
    // vec2 uv2=uv;
    
    // uv2.x=mix(uv.x,uv.y,direction);
    // uv2.y=mix(uv.y,1.-uv.x,direction);
    vec2 uv2=rotatePoint(uv.xy,vec2(.5,.5),direction*2.*PI);
    
    uv2.x+=sin(uv2.y*warpTiling*PI*2.)*warpScale+speed;//u_time/10.;
    uv2.x*=tiles;
    
    float st=floor(fract(uv2.x)+.5);
    
    vec3 color=mix(color1,color2,st);
    
    return vec4(color,1.);
}
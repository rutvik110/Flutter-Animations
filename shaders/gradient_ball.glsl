#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform float width;
uniform float height;
uniform float dragX;
uniform float dragY;

vec2 iResolution=vec2(width,height);
vec2 u_mouse=vec2(dragX,dragY);

out vec4 fragColor;

#define PI 3.14159265358979323846

float rnd(vec2 n){
    return fract(sin(dot(n,vec2(12.9898,4.1414)))*43758.5453);
}

void main(){
    vec2 st=gl_FragCoord.xy/iResolution.xy;
    vec2 center=vec2(.5);
    float distance=distance(st,center);
    float blur=smoothstep(.5,.6,distance);
    float distortion=pow(distance,2.)*.05;
    
    // Calculate the direction vector from the pixel to the center
    vec2 dir=normalize(center-st);
    
    // Calculate the amount of movement based on time and a given speed
    float speed=.1;
    vec2 movement=dir*u_time*speed;
    
    // Apply the movement to the distorted position
    vec2 distortedPosition=st+distortion*(normalize(st-center)+movement);
    
    vec4 color=vec4(st.x,st.y,distortedPosition);
    
    fragColor=mix(color,vec4(0.),blur);
}

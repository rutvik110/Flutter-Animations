

uniform float height;
uniform float width;
uniform float iTime;
uniform float dragX;
uniform float dragY;
uniform float noiseStretchFactor;
uniform sampler2D iChannel0;
out vec4 fragColor;
vec2 iResolution=vec2(width,height);
vec2 dragPoint=vec2(dragX,dragY);

float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453123);}//Pseudo-random
float smoothNoise(in vec2 p){//Bilinearly interpolated noise (4 samples)
    vec2 i=floor(p);vec2 f=fract(p);
    vec2 u=f*f*(3.-2.*f);
    float a=hash(i+vec2(0.,0.));
    float b=hash(i+vec2(1.,0.));
    float c=hash(i+vec2(0.,1.));
    float d=hash(i+vec2(1.,1.));
    return float(a+(b-a)*u.x+(c-a)*u.y+(a-b-c+d)*u.x*u.y)/4.;
}
//Funciton to make the noise continuous while wrapping around angle
float rotatedMirror(float t,float r){
    //t : 0->1
    t=fract(t+r);
    return 2.*abs(t-.5);
}
//Some continous radial perlin noise
const mat2 m2=mat2(.90,.44,-.44,.90);
float radialPerlinNoise(float t,float d){
    const float BUMP_MAP_UV_SCALE=44.2;
    d=pow(d,.1*noiseStretchFactor/10.);//.05);//Impression of speed : stretch noise as the distance increases.
    float dOffset=-floor(iTime*10.)*.1;//Time drift (animation)
    vec2 p=vec2(rotatedMirror(t,.1),d+dOffset);
    float f1=smoothNoise(p*BUMP_MAP_UV_SCALE);
    p=2.1*vec2(rotatedMirror(t,.4),d+dOffset);
    float f2=smoothNoise(p*BUMP_MAP_UV_SCALE);
    p=3.7*vec2(rotatedMirror(t,.8),d+dOffset);
    float f3=smoothNoise(p*BUMP_MAP_UV_SCALE);
    p=5.8*vec2(rotatedMirror(t,0.),d+dOffset);
    float f4=smoothNoise(p*BUMP_MAP_UV_SCALE);
    return(f1+.2*f2+.1*f3+.03*f4)*3.*(.6+noiseStretchFactor*.4);
    
}
//Colorize function (transforms BW Intensity to color)
vec3 colorize(float f,vec2 uv,vec2 altereduv){
    
    float d=distance(vec2(.5),uv.xy);//Squared distance
    float t=.1+atan(uv.y,uv.x)/4.28;//Normalized Angle
    float v=radialPerlinNoise(t,d);
    //Saturate and offset values
    v=-2.5+v*5.;
    //Intersity ramp from center
    v=mix(0.,v,1.*smoothstep(.1,10.,d));
    float pointDistanceFromCenter=distance(vec2(.5),vec2(v));
    
    uv*=(smoothstep(0.,.9,pointDistanceFromCenter));
    
    vec4 iPixel=texture(iChannel0,uv);
    
    f=clamp(f*.95,0.,1.);
    vec3 c=mix(iPixel.rgb,iPixel.rgb,f);//Red-Yellow Gradient
    c=mix(c,vec3(uv.x,uv.y,1),f);//While highlights
    vec3 cAttenuated=mix(vec3(0),c,f+1.);//Intensity ramp
    return cAttenuated;
}
/*vec3 colorize(float f){
    f = clamp(f,0.0,1.0);
    vec3 c = mix(vec3(1.1,0,0), vec3(1,1,0), f); //Red-Yellow Gradient
    c = mix(c, vec3(1,1,1), f*10.-9.);      //While highlights
    vec3 cAttenuated = mix(vec3(0), c, f);       //Intensity ramp
    return cAttenuated;
}*/
//Main image.
void main(){
    vec2 normaluv=gl_FragCoord.xy/iResolution.xy;
    
    // vec2 uv=2.5*(gl_FragCoord.xy-dragPoint.xy*vec2(iResolution.xy))/iResolution.xx;
    vec2 offset=gl_FragCoord.xy-dragPoint.xy;
    vec2 uv=2.5*offset.xy/iResolution.xx;
    float d=dot(uv,uv);//Squared distance
    float t=.1+atan(uv.y,uv.x)/4.28;//Normalized Angle
    float v=radialPerlinNoise(t,d);
    //Saturate and offset values
    v=-2.5+v*5.;
    //Intersity ramp from center
    v=mix(0.,v,1.*smoothstep(0.,.25,d));
    //Colorize (palette remap )
    
    vec3 colorized=colorize(v,normaluv,uv);
    //Colorize (palette remap )
    
    // colorized*=step(5.,1.-distance(vec2(.5),normaluv));
    // colorized*=smoothstep(.5,1.,1.-distance(vec2(.5),normaluv));
    
    fragColor.rgb=colorized;
}
#ifdef GL_ES
precision mediump float;
#endif

uniform float width;
uniform float height;
uniform float iTime;
uniform sampler2D iChannel0;
out vec4 fragColor;
vec2 iResolution=vec2(width,height);

const float PI=3.14159265359;

//blur
// 16x acceleration of https://www.shadertoy.com/view/4tSyzy
// by applying gaussian at intermediate MIPmap level.

const int samples=35,
LOD=2,// gaussian done on MIPmap at scale LOD
sLOD=1<<LOD;// tile size = 2^LOD
const float sigma=float(samples)*.25;

float gaussian(vec2 i){
    return exp(-.5*dot(i/=sigma,i))/(6.28*sigma*sigma);
}

float map(float value,float min1,float max1,float min2,float max2){
    return min2+(value-min1)*(max2-min2)/(max1-min1);
}

vec4 blur(sampler2D sp,vec2 U,vec2 scale){
    vec4 O=vec4(0);
    int s=samples/sLOD;
    
    for(int i=0;i<s*s;i++){
        vec2 d=vec2(i%s,i/s)*float(sLOD)-float(samples)/2.;
        O+=gaussian(d)*textureLod(sp,U+scale*d,float(LOD));
    }
    
    return O/O.a;
}

//

// Custom ease-in function for upward direction
float easeInCubic(float x){
    // return x * x * x;
    return 1.-cos((x*PI)/2.);
}

//wave

float circle(in vec2 _st,in float _radius){
    vec2 dist=_st-vec2(.50,1.);
    float c1=smoothstep(_radius-(_radius*.5),
    _radius,
    dot(dist,dist)*4.);
    float c2=1.-smoothstep(_radius,
        _radius+(_radius*.5),
        dot(dist,dist)*4.);
        
        return c1*c2;
    }
    
    //
    
    void main(){
        // Normalized pixel coordinates (from 0 to 1)
        vec2 uv=gl_FragCoord.xy/iResolution.xy;
        
        float range=(1.+sin(iTime))*.5;// Normalize the time range from 0 to 1
        
        //glow
        float mrange3=map(range,0.,1.,-.2,1.6);
        float pct=distance(uv,vec2(.5,mrange3));
        pct=smoothstep(0.,.25,pct);
        vec3 gcircle=mix(vec3(.8549,.9922,1.),vec3(1.),pct);
        //glow2
        float mrange2=map(range,0.,1.,-.3,1.5);
        float pct2=distance(uv,vec2(.5,mrange2));
        pct2=smoothstep(0.,.25,pct2);
        vec3 gcircle2=mix(vec3(1.,.9882,.8549),vec3(1.),pct2);
        //glow3
        float mrange=map(range,0.,1.,-.4,1.4);
        float pct3=distance(uv,vec2(.5,mrange));
        pct3=smoothstep(0.,.25,pct3);
        vec3 gcircle3=mix(vec3(1.,.8902,.8784),vec3(1.),pct3);
        // glow
        
        //blur
        // TODO: Blur algorithm need to replaced as Flutters shader compiler doesn't support
        // textureLod I guess.
        // float blurpct=smoothstep(0.,1.,uv.y)*range;
        // vec4 blurredPixel=blur(iChannel0,uv,1./iResolution.xy);
        //
        
        // stretch
        float yStretch=easeInCubic(uv.y);
        yStretch=yStretch*.1*range;
        uv.y-=yStretch;
        //
        
        //wave
        float range2=sin(iTime)<0.?0.:sin(iTime);
        vec2 st2=uv;
        float r=5.*(range2);
        float wpct=1.-circle(st2,r);
        vec3 cc=mix(vec3(1.069,1.077,1.100),vec3(1.),wpct);
        cc=pow(cc,vec3(8.));
        float wStretch=st2.y*.3*range2*(wpct-st2.y);
        st2.y+=wStretch;
        vec4 wcolor=texture(iChannel0,st2);
        wcolor*=vec4(cc,1.);
        //
        
        //remove the wstretch
        uv.y+=wStretch;
        //
        
        vec4 color=texture(iChannel0,uv);
        
        color=mix(color,wcolor,vec4(pct));
        // color=mix(color,blurredPixel,vec4(blurpct));
        wcolor=mix(wcolor,color,vec4(pct));
        
        //color=mix(vec4(gcircle,1.),color,vec4(pct));
        // color=mix(vec4(gcircle2,1.),color,vec4(pct2));
        // color=mix(vec4(gcircle3,1.),color,vec4(pct3));
        // TODO: This doesn't renders the glow circles as they should
        // and instead the final result is just a white screen? Doing mix like above
        // works but results in poor quality glow.
        // color*=vec4(gcircle,1.);
        // color*=vec4(gcircle2,1.);
        // color*=vec4(gcircle3,1.);
        
        fragColor=color;
    }
    
    


#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;

vec4 fragment(in vec2 uv,in vec2 fragCoord){
    
    float l,z=u_time;
    vec2 uv2,p=uv;
    uv2=p;
    p-=.5;
    l=length(p);
    uv2+=abs(sin(l*10.-z));
    float point=.01/length(mod(uv2,1.)-.5);
    vec3 c=vec3(point);
    
    return vec4(c/l,u_time);
    
}


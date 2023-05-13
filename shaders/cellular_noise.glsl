

// Author: @patriciogv
// Title: CellularNoise
// Src : Modified version of shader from https://thebookofshaders.com/12/

#ifdef GL_ES
precision mediump float;
#endif

uniform float width;
uniform float height;
uniform float u_time;

vec2 iResolution=vec2(width,height);
out vec4 fragColor;

vec2 random2(vec2 p){
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

void main(){
    vec2 st=gl_FragCoord.xy/iResolution.xy;
    st.x*=iResolution.x/iResolution.y;
    vec3 color=vec3(0.);
    
    // Scale
    st*=2.;
    
    // Tile the space
    vec2 i_st=floor(st);
    vec2 f_st=fract(st);
    
    float m_dist=1.;// minimum distance
    
    for(int y=-1;y<=1;y++){
        for(int x=-1;x<=1;x++){
            // Neighbor place in the grid
            vec2 neighbor=vec2(float(x),float(y));
            
            // Random position from current + neighbor place in the grid
            vec2 point=random2(i_st+neighbor)+sin(u_time/10.);
            
            // Animate the point
            point=.5+.5*sin(u_time/5.+6.2831*point);
            
            // Vector between the pixel and the point
            vec2 diff=neighbor+point-f_st;
            
            // Distance to the point
            float dist=length(diff);
            
            // Keep the closer distance
            m_dist=min(m_dist,dist);
        }
    }
    
    // Draw the min distance (distance field)
    color+=vec3(1.-m_dist);
    color+=vec3(.330,.003,.257);
    color*=vec3(.135,.010,.118);
    color*=vec3(pow(-.528-st.y,2.));
    
    // Show isolines
    // color -= step(.7,abs(sin(27.0*m_dist)))*.5;
    
    fragColor=vec4(color,1.);
}
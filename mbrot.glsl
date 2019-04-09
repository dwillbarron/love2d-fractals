//extern Image input;
//extern vec2 wh;
extern number t;
extern Image rmap;

extern vec2 movexy;


#define ITERS 120

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 px)
{   
    highp vec2 puv = px / love_ScreenSize.xy;
    //puv += movexy;
    puv += vec2(sin(puv.y*5 + t)*0.01, sin(puv.x*5+t)*0.01);
    puv -= movexy;
    puv *= 3 / t;
    puv += movexy;

    //puv = uv;
    int i;
    highp vec2 z = puv;
    for (i = 0; i < ITERS; i++) {
        z = vec2(pow(z.x, 2.0) - pow(z.y, 2.0), z.x * z.y * 2.0);
        z += puv;
        if (length(z) > 2.0) {break;}
    }
    float val = float(i) / float(ITERS);
    vec4 mcolor = vec4(abs(sin(t / 30))*val, abs(cos(t / 20))*val, abs(tan(t / 60))*val, val);
    if (i == ITERS) {mcolor = vec4(0,0,0,1);}
    return mcolor * color;
}
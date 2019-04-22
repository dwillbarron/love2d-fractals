//extern Image input;
//extern vec2 wh;
extern number t;
extern Image rmap;
extern number space;
extern number iterfactor;

extern number shortside;
extern number zoomfactor;
extern number r;
extern number g;
extern number b;

extern number x1;
extern number y1;

extern vec2 movexy;

#define ITERS 10

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 px)
{   
    color = vec4(r / 255.0, g / 255.0, b / 255.0, 1);
    highp vec2 puv = px / shortside;
    // ripple effect
    //puv += vec2(sin(puv.y*5 + t)*0.01, sin(puv.x*5+t)*0.01);
    puv -= vec2(0.5, 0.5);
    puv /= 0.1 * exp(zoomfactor);
    puv += movexy;

    //puv = uv;
    int i;
	int r = 2;
    highp vec2 z = puv;
    // highp vec2 z = vec2(x1, y1);
    for (i = 0; i < iterfactor; i++) {
        z = vec2(pow(z.x, 2.0) - pow(z.y, 2.0), z.x * z.y * 2.0);
        //z += puv;
        z += puv + sin(t / r) * 0.5;
        if (length(z) > 2.0) {break;}
    }
    //float val = float(i) / float(iterfactor);
    //vec4 mcolor = vec4(abs(sin(t / 30))*val*(r/255.0), abs(cos(t / 20))*val*(g/255.0), abs(max(tan(t / 60), 1))*val*(b/255.0), 1);
    if (i == iterfactor) {i = 0;}
    float val = (i / float(iterfactor));
    return vec4(val, val, val, 1) * color;
}
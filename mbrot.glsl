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

extern vec2 c;

extern vec2 movexy;

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 px)
{   
    color = vec4(r / 255.0, g / 255.0, b / 255.0, 1);
    highp vec2 puv = px / shortside;
    puv -= vec2(0.5, 0.5);
    puv /= 0.1 * exp(zoomfactor);
    puv += movexy;
    int i;
	int r = 2;
    highp vec2 z = c;
    // highp vec2 z = vec2(x1, y1);
    for (i = 0; i < iterfactor; i++) {
        z = vec2(pow(z.x, 2.0) - pow(z.y, 2.0), z.x * z.y * 2.0);
        z += puv;
        if (length(z) > 2.0) {break;}
    }
    if (i == iterfactor) {i = 0;}
    float val = (i / float(iterfactor));
    return vec4(val, val, val, 1) * color;
}
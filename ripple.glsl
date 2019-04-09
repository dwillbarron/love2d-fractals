//extern Image input;
//extern vec2 wh;
extern number t;
extern Image rmap;


vec4 effect(vec4 color, Image tex, vec2 uv, vec2 px)
{   
    vec2 puv = px / love_ScreenSize.xy;
    vec2 newuv =uv+ vec2(sin(puv.y*5 + t)*0.1, sin(puv.x*5+t)*0.1);
    vec4 pix = Texel(tex, newuv) * color;
    return vec4(1, 0, 0, 1) * pix;
}
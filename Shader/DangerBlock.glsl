precision lowp float;
precision lowp int;

uniform vec2 reso;
uniform float time;

const float PI    = acos(-1.0);
const float deg45 = PI*0.25;
const float sin45 = sin(deg45);
const float cos45 = cos(deg45);

const vec3 backgroundColor = vec3(1.0);
const vec3 stripeColor     = vec3(1.0, 0.2, 0.2);
const vec3 cautionColor    = vec3(1.0, 0.05, 0.05);

const float p1offsetY = 0.7;
const float p2offsetY = 0.2;
const float p1size = 0.18;
const float p2size = 0.13;
const float stripeSize = 0.1;
const float smoothLen = 0.02;

varying vec4 vertTexCoord;

float dRoundRect(vec2 p, vec2 b, float r)
{
    return length(max(abs(p)-b,0.0))-r;
}
float dCircle(vec2 p)
{
	return length(p);
}
void main( void ) 
{
	vec2 uv = (vec2(vertTexCoord.x, 1.0-vertTexCoord.y)*2.0-1.0)*reso.xy/min(reso.x, reso.y);	
	
	float part1 = smoothstep(p1size, p1size-smoothLen, dCircle(vec2(uv.x, uv.y+p1offsetY)));
	float part2 = smoothstep(p2size, p2size-smoothLen, dRoundRect(vec2(uv.x, uv.y-p2offsetY), vec2(0.01+uv.y*0.15, 0.5), 0.05));
	float caution = part1+part2;
	
	vec2  suv    = vec2(uv.x+time, uv.y)*2.0;
	float rsuvx  = suv.x*cos45-suv.y*sin45;
	float stripe = smoothstep(stripeSize, stripeSize+smoothLen, fract(rsuvx));
	float cut    = mod(floor(rsuvx), 2.0);
	
	gl_FragColor = vec4(mix(mix(backgroundColor, stripeColor, stripe*cut), cautionColor, caution), 1.0);
}

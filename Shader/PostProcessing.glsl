#define PROCESSING_TEXTURE_SHADER

precision lowp float;
precision lowp int;

uniform sampler2D texture;
uniform sampler2D shadowMap;

uniform float time = 0.0;

uniform bool inversed           = false;
uniform bool enabledNoise       = true;
uniform bool enabledSinNoise    = false;
uniform bool enabledCellNoise   = false;
uniform bool enabledLightEffect = false;
uniform bool enabledShadow      = true;

uniform float noiseScale     = 0.0;
uniform float cellnoiseScale = 0.0;
uniform float sandstormScale = 0.0;

uniform float flashOut      = 0.0;
uniform float fadeInOut     = 1.0;
uniform vec3  flashOutColor = vec3(0.0);

uniform float caInterval      = 0.01;
uniform float saturationScale = 1.0;

uniform vec2 lightPosition;
uniform float lightScale   = 1.0;

varying vec4 vertColor;
varying vec4 vertTexCoord;

const float PI      = acos(-1.0);
const float TWO_PI  = PI*2.0;
const float HALF_PI = PI*0.5;

const int   SAMPLE  = 20;
const float POWER   = 1.0/float(SAMPLE);
const float DECAY   = 0.5;

const vec3 GAMMA    = vec3(1.0/2.2);

const vec3 fadeOutColor  = vec3(1.0);

#define saturate(v) clamp(v, 0.0, 1.0)

//https://stackoverflow.com/questions/4200224/random-noise-functions-for-glsl
float rand(vec2 seed)
{
    return fract(sin(dot(seed.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
float rand(float seed)
{
    return fract(sin(mod(seed*12.9898, TWO_PI)) * 43758.5453);
}
vec2 rand2(vec2 seed) 
{
    return fract(sin(vec2(dot(seed,vec2(127.1,311.7)),dot(seed,vec2(269.5,183.3))))*43758.5453);
}

vec3 hsv(float h, float s, float v)
{
    vec4 t = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(vec3(h) + t.xyz) * 6.0 - vec3(t.w));
    return v * mix(vec3(t.x), clamp(p - vec3(t.x), 0.0, 1.0), s);
}
vec3 saturation(vec3 c, float s)
{
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 t = vec3(dot(c, W));
    return mix(t, c, s);
}


void main(void) 
{	
	vec2 uv = vertTexCoord.xy;
	vec2 cuv = uv-0.5;
	float clen = length(cuv);
	uv /= (-clen)*0.1+1.025;
	
	vec2 noise = vec2(0.0);
	if(enabledNoise)
	{
		float iy = floor(uv.y*200.0);
		float iyrand = rand(time*0.1+iy);
		float XShift = pow(iyrand, 5.0)*noiseScale*5.0;
		if(enabledSinNoise)
		{
			XShift *= sin(uv.y*20.0+(time*5.0))*0.5+0.5+0.2;
		}
		
		noise = vec2(XShift, 0.0);
		if(enabledCellNoise)
		{
			vec2 icell = floor(vec2(uv.x*0.1, uv.y)*25.0);
			vec2 cellnoise = (rand2(icell+time)*2.0+(-1.0))*step(rand(icell+time), 0.3)*cellnoiseScale*0.25;
			noise += cellnoise;
		}
	}
	
	vec2 distortedUV = uv+noise;
	vec3 texCol = vec3(texture2D(texture, distortedUV).r, 
				       texture2D(texture, (-cuv)*caInterval+distortedUV).g,
				       texture2D(texture, (-cuv*caInterval)*2.0+distortedUV).b);
	if(inversed)
	{
		texCol = vec3(1.0)-saturate(texCol);
	}

	float uvtrand = rand(uv+fract(time));
	
	if (enabledShadow)
	{
		float shadowWeight = 0.0;
	    vec2 pc = (uvtrand*2.0+(-1.0))*0.01+(lightPosition-uv+noise);
	    for(int i = 0; i < SAMPLE; ++i)
	    {
			shadowWeight += texture2D(shadowMap, float(i)*(DECAY/float(SAMPLE)*pc)+(uv+noise)).r*POWER;
	    }
	    vec3 shadow = mix(texCol, vec3(0.0), min(shadowWeight, 1.0));
	    
		texCol = (texture2D(shadowMap, uv+noise).r == 1.0 ? texCol : shadow);
	}
	
	if(enabledLightEffect)
	{
		texCol *= mix(1.0, max(0.1, (-length(uv-lightPosition))*1.5+1.0), lightScale);
	}
	
	texCol += uvtrand*sandstormScale*0.1; 
	texCol = saturation(texCol, saturationScale);
	texCol = mix(texCol, flashOutColor, flashOut);
	texCol = mix(fadeOutColor, texCol,  fadeInOut);
	texCol = pow(texCol, GAMMA);
	
	float vignette = (-clen)*1.5+1.0;
	float scanline = sin(uv.y*1000.0+time*10.0)*0.05;
	float flicker = step(rand(time*0.0001), 0.5)*0.02+1.0;
	
	vec3 outCol = (texCol*vignette)*flicker+scanline;
	
	gl_FragColor = vec4(outCol, 1.0);
}

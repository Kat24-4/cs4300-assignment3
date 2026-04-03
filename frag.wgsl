@group(0) @binding(0) var<uniform> resolution: vec2f;
@group(0) @binding(1) var videoSampler:   sampler;
@group(0) @binding(2) var backBuffer:     texture_2d<f32>;
@group(0) @binding(3) var<uniform> color: vec3f;
@group(0) @binding(4) var<uniform> speed: f32;
@group(0) @binding(5) var<uniform> mouse: vec3f;
@group(0) @binding(6) var<uniform> frame: f32;
@group(0) @binding(7) var<uniform> frequency: f32;
@group(0) @binding(8) var<uniform> amplitude: f32;
@group(0) @binding(9) var<uniform> noiseFactor: u32;
@group(1) @binding(0) var videoBuffer:    texture_external;

@fragment 
fn fs( @builtin(position) pos : vec4f ) -> @location(0) vec4f {
  let p = pos.xy / resolution;
  let m = mouse.xy;

  let dist = distance(p, m);
  let time = frame / 60.;

  let noiseScale = 3.0;
  let pnoise = perlinNoise2(p * noiseScale + vec2f(time * 0.1, time * 0.1));

  var wave = sin(dist * frequency - time * speed);
  // make ripple effect w/ sin
  if (noiseFactor == 1) {
    wave = sin(dist * frequency - time * speed + pnoise * 2.0);
  }

  // damping 
  let damping = exp(-dist * 4.);

  //distortion
  let noisep = vec2f(perlinNoise2(p * 10.0 + vec2f(0.0, time * 0.1)), 
                     perlinNoise2(p * 10.0 + vec2f(5.0, time * 0.1))) * 0.005;
  let distortion = (p - m) * wave * amplitude * damping;
  var distortedp = p + distortion;

  if (noiseFactor == 1) {
    distortedp = distortedp + noisep;
  }

  let video = textureSampleBaseClampToEdge( videoBuffer, videoSampler, distortedp );

  let fb = textureSample( backBuffer, videoSampler, distortedp );

  let out = video * .05 + fb * .975;

  return vec4f( mix(color, out.rgb, 0.975), 1. );
}

// sourced from https://dekoolecentrale.nl/wgsl-fns/perlinNoise2D
fn perlinNoise2_permute4(x: vec4f) -> vec4f { 
    return ((x * 34. + 1.) * x) % vec4f(289.); 
}

fn perlinNoise2_fade2(t: vec2f) -> vec2f { 
    return t * t * t * (t * (t * 6. - 15.) + 10.); 
}

fn perlinNoise2(P: vec2f) -> f32 {
    var Pi: vec4f = floor(P.xyxy) + vec4f(0., 0., 1., 1.);
    let Pf = fract(P.xyxy) - vec4f(0., 0., 1., 1.);
    Pi = Pi % vec4f(289.); // To avoid truncation effects in permutation
    let ix = Pi.xzxz;
    let iy = Pi.yyww;
    let fx = Pf.xzxz;
    let fy = Pf.yyww;
    let i = perlinNoise2_permute4(perlinNoise2_permute4(ix) + iy);
    var gx: vec4f = 2. * fract(i * 0.0243902439) - 1.; // 1/41 = 0.024...
    let gy = abs(gx) - 0.5;
    let tx = floor(gx + 0.5);
    gx = gx - tx;
    var g00: vec2f = vec2f(gx.x, gy.x);
    var g10: vec2f = vec2f(gx.y, gy.y);
    var g01: vec2f = vec2f(gx.z, gy.z);
    var g11: vec2f = vec2f(gx.w, gy.w);
    let norm = 1.79284291400159 - 0.85373472095314 *
        vec4f(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
    g00 = g00 * norm.x;
    g01 = g01 * norm.y;
    g10 = g10 * norm.z;
    g11 = g11 * norm.w;
    let n00 = dot(g00, vec2f(fx.x, fy.x));
    let n10 = dot(g10, vec2f(fx.y, fy.y));
    let n01 = dot(g01, vec2f(fx.z, fy.z));
    let n11 = dot(g11, vec2f(fx.w, fy.w));
    let fade_xy = perlinNoise2_fade2(Pf.xy);
    let n_x = mix(vec2f(n00, n01), vec2f(n10, n11), vec2f(fade_xy.x));
    let n_xy = mix(n_x.x, n_x.y, fade_xy.y);
    return 2.3 * n_xy;
}
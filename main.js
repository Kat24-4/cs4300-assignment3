import { default as gulls } from 'https://cbcdn.githack.com/charlieroberts/gulls/raw/branch/main/gulls.js'
import { default as Video    } from 'https://cbcdn.githack.com/charlieroberts/gulls/raw/branch/main/helpers/video.js'
import { default as Mouse    } from 'https://cbcdn.githack.com/charlieroberts/gulls/raw/branch/main/helpers/mouse.js'
import {Pane} from 'https://cdn.jsdelivr.net/npm/tweakpane@4.0.5/dist/tweakpane.min.js';

const sg     = await gulls.init(),
      frag   = await gulls.import( './frag.wgsl' ),
      shader = gulls.constants.vertex + frag

await Video.init()

Mouse.init()

const back = new Float32Array( gulls.width * gulls.height * 4 )
const feedback_t = sg.texture( back ) 


const params = { background: { r:0, g:0, b:0  } }
const pane = new Pane()

let noiseBool = 0;

const mouse = sg.uniform( Mouse.values ),
      color = sg.uniform( Object.values( params.background ) ),
      speed = sg.uniform( 3 ),
      frame = sg.uniform( 0 ),
      frequency = sg.uniform( 60 ),
      amplitude = sg.uniform( 0.03 ),
      noise = sg.uniform( 0 )

pane
  .addBinding( params, 'background', { color: { type:'float' } })
  .on( 'change', v => color.value = Object.values( params.background ) )

pane.addBinding( speed, 'value', { min:0.2, max:5, label:'speed' })
pane.addBinding( frequency, 'value', { min:10, max:80, label:'frequency'})
pane.addBinding( amplitude, 'value', { min: 0.005, max:0.05, label:'amplitude'})
const noiseB = pane.addButton({ title:'off', label:'noise'})

noiseB.on('click', () => {
  noiseBool = noiseBool == 0 ? 1 : 0
  noiseB.title = noiseBool == 0 ? 'off' : 'on'
})

const render = await sg.render({
  shader,
  data:[
    sg.uniform([ sg.width, sg.height ]),
    sg.sampler(),
    feedback_t,
    color,
    speed,
    mouse,
    frame,
    frequency, 
    amplitude,
    noise,
    sg.video( Video.element )
  ],
  onframe() { mouse.value = Mouse.values },
  copy: feedback_t
})

sg.run( render )

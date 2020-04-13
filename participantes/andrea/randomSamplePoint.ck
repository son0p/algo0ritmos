// --- cadena de audio
SndBuf mySound => PRCRev reverb => dac;
0.1 => reverb.mix;
// designa un espacio en memoria para el wav
me.dir() + "bird.wav" => string filename;
// lee
filename => mySound.read;

// posicion de inicio aleatoria
Math.random2(0, mySound.samples()) => mySound.pos;
// suena un poco
300::ms => now;

// antes de desaparecer se instancia a sí mismo
Machine.add(me.dir() + "/randomSamplePoint.ck");



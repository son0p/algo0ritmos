// Cadena de audio
// Conectamos un generador de onda sinosoidal
// a una reberveración y luego a al convertidor
// digital análogo (tarjeta de sonido)
SinOsc sinOsc => NRev reverb => dac;
// Asignamos la ganancia al generador sinosoidal
0.05 => sinOsc.gain;
// Asignamos el balance entre señal reverberada y
// señal seca
0.05 => reverb.mix;

// Ciclo infinito donde se asigna una frecuencia
// aleatoria al generador sinosoidal
while(true)
{
    Math.random2(20, 5000) => sinOsc.freq;
    150::ms => now;
}

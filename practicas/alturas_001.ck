// cadena de audio crea y conecta objetos
SinOsc mel => Envelope e => NRev r => dac;
// inicializa atributos de objetos
0.4 => mel.gain;
0.2 => r.mix;

// crea arreglos
[77,0,0, 80,79,75, 0,0,0,80,79,72, 0,0,0,80,79,68, 0, 0, 0, 0] @=> int notas[];
[ 4,4,1,  4, 8, 4, 8,4,1, 4, 8, 4, 8,4,1, 4, 8, 4, 4, 2, 1, 1] @=> int dura[];

// inicializa contadores
0 => int i;
0 => int count;

// procede tocando los arreglos
while(true)
{
  i % (notas.cap()-1) => count;
	Std.mtof(notas[count])=> mel.freq;
	e.keyOn();
	2::second/(dura[count]) => now;
	e.keyOff();
	i++;
}

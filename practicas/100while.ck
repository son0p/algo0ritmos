// sonido que queremos que forme un ritmo
SinOsc sonido => dac;
[60,62,64,65,67,69,71,72] @=> int escalaMayor[];

// ciclo infinito donde suena un ritmo con ticks
while( true )
{
	Std.mtof(escalaMayor[Math.random2(0,7)]) => sonido.freq;
	200::ms => now;
}

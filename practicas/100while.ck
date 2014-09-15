// sonido que queremos que forme un ritmo
Impulse tick => dac;

// ciclo infinito donde suena un ritmo con ticks
while( true )
{
	1.0 => tick.next;
	0.20::second => now;
}

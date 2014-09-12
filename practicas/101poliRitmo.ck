// definimos el tempo y lo asignamos a la duración bit
100 => int tempo;
dur bit;
60.0/(tempo) => float SPB;
SPB::second => bit;

Impulse tick =>TwoPole kp => dac.left;
50.0 => kp.freq; 0.80 => kp.radius; 1 => kp.gain;

Impulse tack =>TwoPole kpa => dac.right;
5000.0 => kpa.freq; 0.99 => kpa.radius; 1 => kp.gain;

fun void ti()
{
	while( true )
	{
		1.0 => tick.next;
		bit => now;
	}
}

fun void ta()
{
	while( true )
	{
		1.0 => tack.next;
		(bit*2)/3 => now;
	}
}

spork~ ti();
spork~ ta();
while(true){ bit*8 => now;}
0.50::second => dur bit;
29 => int root;

Impulse kick => TwoPole kp => dac;
50.0 => kp.freq; 0.99=> kp.radius; 1 => kp.gain;

Noise n => ADSR snare => TwoPole sp => Delay sdel => dac;
800.0 => sp.freq; 0.9 => sp.radius; 0.1 => sp.gain;
snare.set(0.001,0.1,0.0,0.1);

Noise h => ADSR hihat => TwoPole hsp => Delay hdel => dac;
5000.0 => hsp.freq; 0.9 => hsp.radius; 0.1 => hsp.gain;
hihat.set(0.001,0.1,0.0,0.1);

SawOsc bass => Envelope e => dac;
0.3 => bass.gain;

TriOsc mel => Envelope eMel => NRev rMel => dac;
0.8 => mel.gain;
0.1 => rMel.mix;

fun void kk()
{
while(true)
	{
		1.0 => kick.next;
		bit => now;
	}
}

fun void sn()
{
	while( true )
	{
		bit => now;
		snare.keyOn();
		bit => now;
		snare.keyOff();
	}
}

fun void hh()
{
	while(true)
	{
		bit/2 => now;
		hihat.keyOn();
		bit/2 => now;
		hihat.keyOff();
	}
}

fun void bs()
{
	while(true)
	{
		Std.mtof( root ) => bass.freq; e.keyOn(); bit/2 => now; e.keyOff();
		Std.mtof( root + 12) => bass.freq; e.keyOn(); bit/2 => now; e.keyOff();
	}
}

fun void ml()
{
	0 => int i;
	
	while (true)
	{
		[67, 62, 0, 60, 65, 60, 0, 0, 60, 0, 0, 62] @=> int opt[];
		Std.mtof(opt[i])=> mel.freq;
		eMel.keyOn();
		bit/2 => now;
		eMel.keyOff();
		i++;
		
	}
}
		

spork~ kk();
spork~ sn();
spork~ hh();
spork~ bs();
spork~ ml();

while(true){ 8*bit => now;}
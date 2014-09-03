120 => int tempo;
dur bit;
60.0/(tempo) => float SPB;
SPB::second => bit;

35 => int root;
//80.0 => float root;


Impulse kick =>TwoPole kp => dac;
50.0 => kp.freq; 0.99 => kp.radius; 1 => kp.gain;

Noise n => ADSR snare => TwoPole sp => Delay sdel => dac;
800.0 => sp.freq; 0.9 => sp.radius; 0.1 => sp.gain;
snare.set(0.001,0.1,0.0,0.1);

Noise h => ADSR hihat => TwoPole hsp => Delay hdel => dac;
5000.0 => hsp.freq; 0.9 => hsp.radius; 0.1 => hsp.gain;
hihat.set(0.001,0.1,0.0,0.1);

SawOsc bass => Envelope e => dac;
0.3 => bass.gain;
TriOsc mel => Envelope eMel => NRev rMel => dac;
0.3 => mel.gain;
0.2 => rMel.mix;

fun void kk()
{
	while(true)
	{
		1.0 => kick.next;
		1*bit => now;
	}
}

fun void sn()
{
	while(true)
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
		bit => now;
		Std.mtof(root) => bass.freq;
		e.keyOn();
		bit/2 => now;
		e.keyOff();
		Std.mtof(root)+12 => bass.freq;
		e.keyOn();
		bit/4 => now;
		e.keyOff();
		//float seed;
		[0, 3,3,7] @=> int opt[];
		Math.random2(0, opt.cap()-1) => int sel;
		Std.mtof(root*opt[sel]) => bass.freq;
		e.keyOn();
		bit/4 => now;
		e.keyOff();
	}
}

// melody
fun void ml()
{


	while(true)
	{
	
		//float seed;
		[0,0,0, 3, 7 ] @=> int opt[]; // opciones de distancias de la nota raiz en semitonos
		Math.random2(0, opt.cap()-1) => int sel;
		Std.mtof(root+opt[sel]) => mel.freq;
		eMel.keyOn();
		[1,1,1,2,2,4,3] @=> int optBit[];
		Math.random2(0, optBit.cap()-1) => int selBit;
		bit/4 => now;
		eMel.keyOff();
		<<< mel.freq()>>>;
	}


	
}



spork~ kk();
spork~ sn();
spork~ hh();
spork~ bs();
spork~ ml();
	



while(true)
{
	8*bit => now;
}
500::ms => dur bit;

29 => int root;

Impulse kick =>TwoPole kp => dac;
50.0 => kp.freq; 0.99 => kp.radius; 1 => kp.gain;

Noise n => ADSR snare => TwoPole sp  => dac;
800.0 => sp.freq; 0.9 => sp.radius; 0.1 => sp.gain;
snare.set(0.001,0.1,0.0,0.1);

Noise h => ADSR hihat => TwoPole hsp => dac;
5000.0 => hsp.freq; 0.9 => hsp.radius; 0.1 => hsp.gain;
hihat.set(0.001,0.1,0.0,0.1);

SawOsc bass => Envelope e => dac;
0.3 => bass.gain;

TriOsc mel => Envelope eMel => NRev rMel => dac;
0.5 => mel.gain;
0.1 => rMel.mix;

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
		
		Std.mtof( root -2) => bass.freq;e.keyOn(); bit/2 => now; 	e.keyOff();
		Std.mtof( root + 10 ) => bass.freq; e.keyOn(); bit/2 => now; e.keyOff();
		Std.mtof( root -2) => bass.freq; e.keyOn(); bit/2 => now; e.keyOff();
		Std.mtof( root + 10 ) => bass.freq; e.keyOn(); bit/2 => now; e.keyOff();
		0 => int i;
		until ( i == 6 )
		{
			Std.mtof( root ) => bass.freq;e.keyOn(); bit/2 => now; 	e.keyOff();
			Std.mtof( root + 12 ) => bass.freq; e.keyOn(); bit/2 => now; e.keyOff();
			i++;
		}
	}
}

// melody
fun void ml()
{
	while(true)
	{
		//** Comenta y descomenta las líneas de código
		//** de cada bloque para escuchar cambios

		//-------------- Notas aleatorias sin armonía
		// Std.mtof(Math.random2(31, 71)) => mel.freq;
		// eMel.keyOn();
		// bit/2 => now;
		// eMel.keyOff();
	
		//-------------Seleccionar notas en orden de algunas posibilidades
		// [57, 60, 62, 65, 67] @=> int opciones[];
		// for (0 => int i; i < opciones.cap(); i++)
		// {
		// 	Std.mtof(opciones[i]) => mel.freq;
		// 	eMel.keyOn();
		// 	bit/2 => now;
		// 	eMel.keyOff();
		// }


		//-------------Seleccionar notas aleatorias solo de unas opciones
		// [57, 60, 62, 65, 67] @=> int options[];
		// for (0 => int i; i < options.cap(); i++)
		// {
		// 	Math.random2(0, options.cap()-1) => int select;
		// 	Std.mtof(options[select]) => mel.freq;
		// 	eMel.keyOn();
		// 	bit/2 => now;
		// 	eMel.keyOff();
		// }

		//------------- Notas y ritmo aleatorios solo de unas opciones
		// [57, 60, 62, 65, 67] @=> int options[];
		// [1, 2, 4, 3] @=> int div[];
		// for (0 => int i; i < options.cap(); i++)
		// {
		// 	Math.random2(0, options.cap()-1) => int select;
		// 	Std.mtof(options[select]) => mel.freq;
		// 	eMel.keyOn();
		// 	Math.random2(0, div.cap()-1) => int divBit; 
		//	bit/divBit => now;
		// 	eMel.keyOff();
		// }


		//------------- aumentar probabilidades de unas mas que otras
		// [57, 60, 60, 60, 62, 62, 65, 67] @=> int options[];
		// [1, 2, 2, 2, 2, 2, 2, 2, 3] @=> int div[];
		// for (0 => int i; i < options.cap(); i++)
		// {
		// 	Math.random2(0, options.cap()-1) => int select;
		// 	Std.mtof(options[select]) => mel.freq;
		// 	eMel.keyOn();
		// 	Math.random2(0, div.cap()-1) => int divBit; 
		// 	bit/div[divBit] => now;
		// 	eMel.keyOff();
		// }
	
	}
}

spork~ kk();
spork~ sn();
spork~ hh();
spork~ bs();
spork~ ml();

while(true)
{
	bit => now;
}
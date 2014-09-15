// * Para correr este archivo de manera
// * infinita, edite y ejecute looper.ck
// * En looper.ck edite de la siguiente manera
// * Machine.add(me.dir()+"/300densidad.ck") => int fileID;
// * Luego ejecute looper.ck

// Determinamos una duración para lo que
// va a ser nuestro beat.
500::ms => dur bit;

// Definimos la nota raiz.
29 => int root;

// Hacemos un bombo, filtrando un Impuslo.
Impulse kick =>TwoPole kp => dac;
50.0 => kp.freq; 0.99 => kp.radius; 1 => kp.gain;

// Hacemos un redoblante, filtrando un Noise.
Noise n => ADSR snare => TwoPole sp  => dac;
800.0 => sp.freq; 0.9 => sp.radius; 0.1 => sp.gain;
snare.set(0.001,0.1,0.0,0.1);

// Hacemos un charles, filtrando un Noise.
Noise h => ADSR hihat => TwoPole hsp => dac;
5000.0 => hsp.freq; 0.9 => hsp.radius; 0.1 => hsp.gain;
hihat.set(0.001,0.1,0.0,0.1);

// Hacemos un bajo y le asingamos
// una ganancia (volumen).
SawOsc bass => Envelope e => dac;
0.3 => bass.gain;

// Iniciamos varios instrumentos
[0, 3, 7, 12, 24] @=> int notes[];
TriOsc chord[notes.cap()];
Gain  master => Envelope eChord => dac;
for( 0 => int i; i < chord.cap(); i++ )
{
 	chord[i] => master;
	0.2 => chord[i].gain;
}

// Hacemos un sonido para melodía
// y la pasamos por una reverberación.
TriOsc mel => Envelope eMel => NRev rMel => dac;
0.3 => mel.gain;
0.1 => rMel.mix;

// Una función que suena un bombo cada beat.
fun void kk()
{
	while(true)
	{
		1.0 => kick.next;
		1*bit => now;
	}
}

// Una función que ejecuta un redoblante
// dejando una negra en silencio. 
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

// Una función que ejecuta el hihat
// dejando un silencio de corchea.
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

// Un bajo que se ejecuta en corcheas (bit/2)
// y variando la distancia de la nota raiz
// (root -2)(root + 10)etc. Para la última parte
// de la ejecución, que se repite igual 6 veces,
// se hace con un ciclo lógico "until".
fun void bs()
{
	while(true)
	{
		Std.mtof( root -2) => bass.freq;e.keyOn(); bit/2 => now; e.keyOff();
		Std.mtof( root + 10 ) => bass.freq; e.keyOn(); bit/2 => now; e.keyOff();
		Std.mtof( root -2) => bass.freq; e.keyOn(); bit/2 => now; e.keyOff();
		Std.mtof( root + 10 ) => bass.freq; e.keyOn(); bit/2 => now; e.keyOff();
		0 => int i;
		until ( i == 6 )
		{
			Std.mtof( root ) => bass.freq;e.keyOn(); bit/2 => now; e.keyOff();
			Std.mtof( root + 12 ) => bass.freq; e.keyOn(); bit/2 => now; e.keyOff();
			i++;
		}
	}
}
 dur length; // hardcode

// Función para acordes
fun void ch( int root, int notes[], int div)
{
	while(true)
	{
		for( 0 => int i; i < notes.cap(); i++)
		{
			Std.mtof(root + notes[i]) => chord[i].freq;
			
		}
		eChord.keyOn();
		bit/div => now;
		eChord.keyOff();
		bit/div => now;
		
	}
	
}

// Función para la melodia.
fun void ml(int div)
{
	while(true)
	{
		[root+24, root+24, root+24, root+27] @=> int opciones[];
		for (0 => int i; i < opciones.cap(); i++)
		{
			Std.mtof(opciones[i]) => mel.freq;
			eMel.keyOn();
			bit/div => now;
			eMel.keyOff();
			bit/div => now;
			
		}


	}
}

// Se llaman todas las funciones. 
spork~ kk();
spork~ sn();
spork~ hh();
spork~ bs();
spork~ ch(root+36, notes, 6);
spork~ ml(2);

// Un ciclo infinito para mantener vivos los llamados a las funciones.
while(true)
{
	bit => now;
}
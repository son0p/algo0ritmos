// Determinamos una duración para lo que
// va a ser nuestro beat.
500::ms => dur beat;

// Definimos la nota raiz.
28 => int root;

// Hacemos un bajo y le asingamos
// una ganancia (volumen).
SinOsc bass => Envelope e => dac;
// Hacemos un sonido para melodía
// y la pasamos por una reverberación.
TriOsc mel => Envelope eMel => NRev rMel => dac;

// Intervalos que se usarán para los acordes,
// Puede poner tantos elementos como quiera
// en el array.
[0, 3, 7, 12, 14] @=> int notes[];

// Se crean tantos instrumentos como elementos
// del array.
SawOsc chord[notes.cap()];

// Se hace que todos los instrumentos
// pasen por un Gain, Envelope, Nrev, y Pan.
Gain master => Envelope eChord => NRev rCh => Pan2 p => dac;

// ------Mixer-------
0.1 => mel.gain;
0.1 => rMel.mix;
0.2 => bass.gain;
// Ganancia acordes.
0.1 => float initGain;
0.01 => rCh.mix; 

// Se pasan todos los instrumentos por
// la cadena de audio del master.
for( 0 => int i; i < chord.cap(); i++ )
{
 	chord[i] => master;
}

// Un bajo que se ejecuta en corcheas (beat/2)
// y variando la distancia de la nota raiz
// (root -2)(root + 10)etc. Para la última parte
// de la ejecución, que se repite igual 6 veces,
// se hace con un ciclo lógico "until".
fun void bs()
{
	while(true)
	{
		Std.mtof( root -2) => bass.freq;e.keyOn(); beat/2 => now; e.keyOff();
		Std.mtof( root + 10 ) => bass.freq; e.keyOn(); beat/2 => now; e.keyOff();
		Std.mtof( root -2) => bass.freq; e.keyOn(); beat/2 => now; e.keyOff();
		Std.mtof( root + 10 ) => bass.freq; e.keyOn(); beat/2 => now; e.keyOff();
		0 => int i;
		until ( i == 6 )
		{
			Std.mtof( root ) => bass.freq;e.keyOn(); beat/2 => now; e.keyOff();
			Std.mtof( root + 12 ) => bass.freq; e.keyOn(); beat/2 => now; e.keyOff();
			i++;
		}
	}
}
 
// Función para acordes
fun void ch( int root, int notes[], int div1, int div2)
{
	while(true)
	{
		for( 0 => int i; i < notes.cap(); i++)
		{
			Std.mtof(root + notes[i]) => chord[i].freq;
			Math.random2f(0.0, initGain) => chord[i].gain;
			Math.random2f(-1, 1) => p.pan;
		}
		eChord.keyOn();
		beat/div1 => now;
		eChord.keyOff();
		beat/div2 => now;
	}
}

// Función para la melodia.
fun void ml(int div1, int div2)
{
	while(true)
	{
		[24, 26, 0, 26] @=> int opciones[];
		[ 4,  2,  4, 2] @=> int dura[];
		for (0 => int i; i < opciones.cap(); i++)
		{
	
			eMel.keyOn();
			Std.mtof(root+ 12+ opciones[i]) => mel.freq;
			beat/dura[i] => now;
			eMel.keyOff();
		//	[1,1,1,1,1,2,2,2,4,4,4,8] @=> int seed[];
		//	beat/seed[(Math.random2(0, seed.cap()-1))] => now;
			beat/dura[i] => now;
		}
	}
}

// Se llaman todas las funciones. 
// -Bajo
spork~ bs();
// -Acordes
spork~ ch(root+36, notes, 12, 4);
// Melodía
spork~ ml(4, 4);

// vive un tiempo
beat*16 => now;
// antes de morir  se crea  a sí mismo
Machine.add(me.dir() + "/300densidad.ck");


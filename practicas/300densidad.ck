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



// Hacemos un bajo y le asingamos
// una ganancia (volumen).
SawOsc bass => Envelope e => dac;
0.3 => bass.gain;

// Iniciamos varios instrumentos
[0, 3, 7, 12, 14] @=> int notes[];
//[0, 5, 0, 5 ] @=> int notes[];
SawOsc chord[notes.cap()];
 Gain master => Envelope eChord => NRev rCh => Pan2 p => dac;
0.1 => rCh.mix; 
0.3 => float initGain;

for( 0 => int i; i < chord.cap(); i++ )
{
 	chord[i] => master;
}

// Hacemos un sonido para melodía
// y la pasamos por una reverberación.
TriOsc mel => Envelope eMel => NRev rMel => dac;
0.3 => mel.gain;
0.1 => rMel.mix;


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
		bit/div1 => now;
		eChord.keyOff();
		bit/div2 => now;
		
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

//spork~ bs();

//Drummer dr; //produce segmentation fault
spork~ ch(root+36, notes, 12, 4);
spork~ ml(2);

// Un ciclo infinito para mantener vivos los llamados a las funciones.
while(true)
{
	bit => now;
}
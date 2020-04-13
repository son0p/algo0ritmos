// vamos a hacer un acorde definiendo una nota de base
// y para las siguientes voces iremos incrementando, de manera aleatoria,
// terceras mayores o terceras menores

// determinamos una duración para lo que
// va a ser nuestro beat.
600::ms => dur beat;
// Definimos la nota raiz.
57 => int root;
// tipos de intervalos (3 semitonos son un intervalo menor,
// 4 semitonos un intervalo mayor)
[3,4] @=> int intervals[];
// cuantas notas va a tener nuestro acorde
int chord[3];
// se crean las voces necesarias para el tamaño del acorde
SinOsc voices[chord.cap()];

// -- Cadena de audio
//  hace que todas las voces pasen
// pasen por un Gain, Envelope, Nrev
Gain master => ADSR eChord => NRev rCh =>  dac;
// ------Mixer-------
// Ganancia inicial de las voces
0.1 => float initGain;
// algo de reverb
0.03 => rCh.mix;
// defino la envolvente
eChord.set( 10::ms, 400::ms, .01, 100::ms );
// se conectan todas las voces a la cadena de audio
for( 0 => int i; i < chord.cap(); i++ )
{
 	voices[i] => master;
}

// funciones
fun void playChord(int baseNote)
{
  for( 0 => int i; i < chord.cap(); i++)
	{
    Std.mtof(baseNote) => voices[i].freq;
    initGain => voices[i].gain;
    // se va incrementando la siguiente voz del acorde de manera aleatoria
    // entre tercera mayor o tercera menor.
    baseNote + intervals[Math.random2(0, intervals.cap()-1)] => baseNote;
	}
  eChord.keyOn();
  beat*2 => now;
  eChord.keyOff();
}

// Se llaman todas las funciones. 
spork~ playChord(root);

// vive un tiempo
beat*2 => now;
// antes de morir  se crea  a sí mismo
Machine.add(me.dir() + "/gen_densidad_001.ck");


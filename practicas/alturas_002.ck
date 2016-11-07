// Determinamos una duración para lo que
// va a ser nuestro beat.
500::ms => dur beat;

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

// Hacemos un sonido para melodía
// y la pasamos por una reverberación.
TriOsc mel => Envelope eMel => NRev rMel => dac;
0.5 => mel.gain;
0.1 => rMel.mix;

// Una función que suena un bombo cada beat.
fun void kk()
{
  while(true)
  {
    1.0 => kick.next;
    1*beat => now;
  }
}

// Una función que ejecuta un redoblante
// dejando una negra en silencio. 
fun void sn()
{
  while(true)
  {
    beat => now;
    snare.keyOn();
    beat => now;
    snare.keyOff();
  }
}

// Una función que ejecuta el hihat
// dejando un silencio de corchea.
fun void hh()
{
  while(true)
  {
    beat/2 => now;
    hihat.keyOn();
    beat/2 => now;
    hihat.keyOff();
  }
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
// Función para la melodia.
fun void ml()
{
  while(true)
  {
    //** Comenta y descomenta las líneas de código
    //** de cada bloque para escuchar cambios.

    //-------- Notas aleatorias sin armonía.
    Std.mtof(Math.random2(31, 71)) => mel.freq;
    eMel.keyOn();
    beat/2 => now;
    eMel.keyOff(
      );
	
    //-------- Seleccionar solo determinadas notas
    ////------ en orden.
    // [57, 60, 62, 65, 67] @=> int opciones[];
    // for (0 => int i; i < opciones.cap(); i++)
    // {
    // 	Std.mtof(opciones[i]) => mel.freq;
    // 	eMel.keyOn();
    // 	beat/2 => now;
    // 	eMel.keyOff();
    // }


    //--------- Seleccionar notas aleatorias
    //--------- de solo de unas opciones (array).
    // [57, 60, 62, 65, 67] @=> int options[];
    // for (0 => int i; i < options.cap(); i++)
    // {
    // 	Math.random2(0, options.cap()-1) => int select;
    // 	Std.mtof(options[select]) => mel.freq;
    // 	eMel.keyOn();
    // 	beat/2 => now;
    // 	eMel.keyOff();
    // }

    //---------- Notas y ritmo aleatorios
    //---------- seleccionados de determinados arrays.
    // [57, 60, 62, 65, 67] @=> int options[];
    // [1, 2, 4, 3] @=> int div[];
    // for (0 => int i; i < options.cap(); i++)
    // {
    // 	Math.random2(0, options.cap()-1) => int select;
    // 	Std.mtof(options[select]) => mel.freq;
    // 	eMel.keyOn();
    // 	Math.random2(0, div.cap()-1) => int divBeat; 
    // 	beat/divBeat => now;
    // 	eMel.keyOff();
    // }


    //---------- Aumentar probabilidades de unas mas que otras
    //---------- repitiendo varias veces un valor en un array.
    // [57, 60, 60, 60, 62, 62, 65, 67] @=> int options[];
    // [1, 2, 2, 2, 2, 2, 2, 2, 3] @=> int div[];
    // for (0 => int i; i < options.cap(); i++)
    // {
    //  	Math.random2(0, options.cap()-1) => int select;
    //  	Std.mtof(options[select]) => mel.freq;
    //  	eMel.keyOn();
    //  	Math.random2(0, div.cap()-1) => int divBeat; 
    //  	beat/div[divBeat] => now;
    //  	eMel.keyOff();
    // }
  }
}

// Se llaman todas las funciones. 
spork~ kk();
spork~ sn();
spork~ hh();
spork~ bs();
spork~ ml();

// marco de tiempo donde estan vivos los sporks
beat*8 => now;
// al finalizar se agrega a si mismo
Machine.add(me.dir() + "/alturas_002.ck");

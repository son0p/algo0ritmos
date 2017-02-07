// un filtro va subiendo la frecuencia
// cuando se acerca al final del ciclo

// definimos la duración de un beat y de un ciclo
120::ms => dur beat;
32 * beat => dur loop; // puede cambiar el tamaño del loop multiplicando por otro número

// voces
// --snareDrum
Noise myNoiseImpulse => ResonZ myNoiseFilter => ADSR myNoise => dac;
0.7 => myNoiseImpulse.gain;
100.0 => float filterFreq;
myNoiseFilter.set(filterFreq, 1.0);
myNoise.set( 0::ms, 50::ms, .1, 100::ms );

// función que usa probabilidades para activar los instrumentos
fun void playNoise()
{
  while(true)
  {
    myNoise.keyOff();
    myNoise.keyOn(); 
    beat => now;
  }
}

fun void playFilter()
{
  loop - (loop/3) => now; // cambien los valores que dividen loop a 4 o a 2
  while(true)
  {
    myNoiseFilter.set(filterFreq, 1.0);
    filterFreq + 100 => filterFreq;
    beat/4 => now;
  }
}

// llama funciones
spork~ playNoise();
spork~ playFilter(); // descomente este spork para ejecutar el filtro

// vive un tiempo
loop => now;
// antes de morir  se crea  a sí mismo
Machine.add(me.dir() + "/gen_texture_001.ck");



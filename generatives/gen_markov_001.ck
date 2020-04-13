320::ms => dur beat;
45.0 => float root;
32 * beat => dur loop;

SinOsc sine => ADSR eSine => dac;
0.5 => sine.gain;
eSine.set( 10::ms, 150::ms, .3, 10::ms );

// dos estados posibles:
// 0.0 va a sumar cero a la nota raíz
// 12.0 va a  suma 12 a la nota raíz
[0.0,12.0] @=> float posibleStates[];

//  ----------- Matriz de transición ----------
//                 a c t u a l 
//                  |      |
//                  V      V
//                 root   octava
// p             +-----------------+
// r    root     |  0.0   |  0.5   |
// o             +--------+--------+
// x   octava    |  1.0   |  0.5   |
// i             +--------+--------+
// m
// o

// convierte la matrxíz de transición a un array multidimensional
[[0.0,0.5],
 [1.0,0.5]] @=> float transitionMatrix[][];

// función para generar probabilidades 
fun float floatChance( int percent, float value1, float value2)
{
  float percentArray[100];
  for( 0 => int i; i < 100; i++ )
  {
    if( i < percent ) value1 => percentArray[i];
    if( i >= percent ) value2 => percentArray[i];
  }
  percentArray[Math.random2(0, percentArray.cap()-1)] => float selected;
  return selected;
}

// estado actual solo se usa al iniciar
12.0 => float currentState;

fun void playMarkov()
{
  while(true)
  {
    // recorre la cantidad de estados posibles
    for( 0 => int i; i < posibleStates.cap(); i++)
    {
      eSine.keyOff();
      // si el estado actual es igual a al estado que hay en la posición i
      // trae el porcentaje correspondiente de la matríz de transición
      // para usarlo al llamar la función de probabilidad y renovar
      // el estado actual, luego suma el estado actual a la nota raiz
      // y asigna la frecuencia al instrumento sine
      if( currentState == posibleStates[i] )
      {
        (transitionMatrix[i][i] * 100.0) $ int => int percent;
        floatChance( percent,posibleStates[0],posibleStates[1] ) => currentState;
        Std.mtof(root + currentState) => sine.freq;
        eSine.keyOn();
        <<< currentState >>>;
        beat => now;
      }
    }
  }
}
// llama la función
spork~ playMarkov();
// mantiene vivas las funciones un ciclo
loop => now;
// al terminar se llama a si mismo
Machine.add(me.dir() + "/gen_markov_001.ck");

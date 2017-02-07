220::ms => dur beat;
45.0 => float root;
16 * beat => dur loop;

// --Melody
BlitSaw melodyImpulse => ADSR melody => NRev mReverb => dac;
0.09 => melodyImpulse.gain;
melody.set( 0::ms, 80::ms, melodyImpulse.gain()/1.5, 100::ms );
0.03 => mReverb.mix;

SinOsc sine => ADSR eSine => dac;
0.5 => sine.gain;
eSine.set( 10::ms, 150::ms, .3, 10::ms );

// dos estados posibles:
// 0.0 va a sumar cero a la nota raíz
// 12.0 va a  suma 12 a la nota raíz
[0.0,12.0,7.0] @=> float posibleStates[];

/*
 = Matriz de transición =
               ---- a c t u a l ----
                 |      |         |
                 V      V         V
                root   octava    quinta
 p             +-----------------+------+
 r    root     |  0.0   |  0.5   | 0.4  |
 o             +--------+--------+------+
 x   octava    |  1.0   |  0.5   | 0.3  |
 i             +--------+--------+------+
 m   quinta    |  0.0   |  0.0   | 0.3  |
 o             +--------+--------+------+

*/

// convierte la matrxíz de transición a un array multidimensional
[
 [0.0,0.5,0.4],
 [1.0,0.5,0.3],
 [0.0,0.0,0.3]
 ] @=> float transitionMatrix[][];

// función para generar probabilidades 

float percentArray[100];
100 => int remain;
fun float floatChance2( int percent, float value )
{
  
    for(0 => int k; k < 100; k++)
  {
    if(percentArray[k] == 0)
    {
      k =>  remain;
    }
  }
  for( remain => int i; i < 100; i++ )
  {
    if( percentArray[i] == 0)
    {
      //if( i < percent ) value => percentArray[i];
      value => percentArray[i];
      //<<<"fill", value, i>>>;
    }
  }
}

fun float chanceResult()
{
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
      melody.keyOff();
      0 => int percent;
      // si el estado actual es igual a al estado que hay en la posición i
      // trae el porcentaje correspondiente de la matríz de transición
      // para usarlo al llamar la función de probabilidad y renovar
      // el estado actual, luego suma el estado actual a la nota raiz
      // y asigna la frecuencia al instrumento sine
      if( currentState == posibleStates[i] )
      {
        for( 0 => int j; j < posibleStates.cap(); j++)
        {
          (transitionMatrix[i][j] * 100.0) $ int =>   percent;
          //floatChance2( percent, posibleStates[j] );
          floatChance2( 70, 3.0 );
          chanceResult() => currentState;
          //0.0 => currentState;
          //<<< chanceResult() >>>;
          Std.mtof(root + 12.0 + currentState) => melodyImpulse.freq;
        }
        melody.keyOn();
        //<<< currentState >>>;
        beat => now;
      }
    }
  }
}
// llama la función
//spork~ playMarkov();
/*
(transitionMatrix[1][1] * 100) $ int => int  percent;
floatChance2(percent, posibleStates[1]);
beat => now;
floatChance2(50, posibleStates[2]);

*/

floatChance2( 40, 3.0 );
for(0 => int k; k < 100; k++){<<< percentArray[k], "position:",k >>>;}
4 * beat => now;
floatChance2(50, 1.1);
for(0 => int k; k < 100; k++){<<< percentArray[k], "position2:",k >>>;}


// mantiene vivas las funciones un ciclo
loop => now;
// al terminar se llama a si mismo
Machine.add(me.dir() + "/gen_markov_002.ck");

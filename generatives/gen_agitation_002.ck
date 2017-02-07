// define tempo
120::ms => dur beat;
36 => int root;

// Probabilidad de un corpus
[100,  0,  0, 0,100,  0, 10,  0,100,  0,  0,  0,100,  0,  0, 20] @=> int chanceBd[]; 
[  0,  0,  0, 0,100,  0,  0,  0,  0,  0,  0,  0,100,  0,  0, 15] @=> int chanceSd[];
[  0,  0,100, 0,  0,  3,100,  0,  5,  5,100,  3,  0,  0,100, 20] @=> int chanceHh[];
[ 13,  3, 90, 3, 10,  3, 90, 15,  5,  5, 90,  3,  5,  5, 90,  3] @=> int chanceBass[];
[  0,  0,  0, 0,  0,  3,  3,  3,  7,  0, 10, 12, 24,  0,  0, -2] @=> int chanceBassNotes[];
[ 10,  15, 5, 30, 15, 10, 10, 30, 90,  5,  0,  3, 30,  15, 0, 30] @=> int chanceMelody[];
// TODO:1. array multidimensional
// 0 step
//   0 root
//   [] step
//   [][] curva de probabilidad de cada posición
[
 [50, 0, 0, 0, 0, 0, 0, 0, 0,0, 99, 0, 0, 0, 0, 0],
 [90, 0, 0,50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
 [ 0, 0, 0,50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
 [ 0, 0, 0,50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
 [ 0, 0, 0,50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
 [10, 0, 0,90, 0, 0, 0,99, 0, 0, 0, 0, 0, 0, 0, 0],
 [90, 0, 0,50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
 [90, 0, 0,50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
 [90, 0, 0,50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
 [ 0, 0, 0,50, 0, 0, 0, 0, 0,99, 0, 0, 0, 0, 0, 0],
 [ 0, 0, 0,50, 0, 0, 0, 0, 0,99, 0, 0, 0, 0, 0, 0],
 [ 0, 0, 0,50, 0, 0, 0, 0, 0,99, 0,99, 0, 0, 0, 0],
 [ 0, 0, 0,50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
 [ 0, 0, 0,50, 0, 0, 0, 0, 0, 0, 0, 0,99, 0, 0, 0],
 [ 0, 0, 0,50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
 [90, 0, 0,50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
] @=>  int chanceMelodyNote[][];

// instrumentos
// --bassDrum 
Impulse bdImpulse => ResonZ bdFilter => ADSR bd => dac;
1000 => bdImpulse.gain;
bdFilter.set(50.0, 10.0);
bd.set( 1::ms, 150::ms, .50, 100::ms );
// --snareDrum
Noise sdImpulse => ResonZ sdFilter => ADSR sd => dac;
0.9 => sdImpulse.gain;
sdFilter.set(400.0, 1.0);
sd.set( 0::ms, 50::ms, .1, 100::ms );
// --hiHat
Noise hhImpulse => ResonZ hhFilter => ADSR hh => dac;
0.5 => hhImpulse.gain;
hhFilter.set(10000.0, 5.0);
hh.set( 0::ms, 50::ms, .1, 100::ms );
// --bass
SqrOsc saw => ADSR bass => dac;
0.15 => saw.gain;
bass.set( 0::ms, 80::ms, saw.gain()/1.5, 100::ms );
// --Melody
BlitSaw sin1 => ADSR melody1 => NRev melodyReverb => dac;
0.35 => sin1.gain;
melody1.set( 0::ms, 80::ms, saw.gain()/1.5, 100::ms );
0.03 => melodyReverb.mix;

// función para generar probabilidades 
fun float floatChance( int percent, float value1, float value2)
{
  float percentArray[100];
  for( 0 => int i; i < 100; i++)
    {
      if( i < percent ) value1 => percentArray[i];
      if( i >= percent ) value2 => percentArray[i];
    }
  percentArray[Math.random2(0, percentArray.cap()-1)] => float selected;
  return selected;
}

// función que usa probabilidades para activar los instrumentos
fun void playDrums()
{
  0 => int i;
  while(true)
  {
    floatChance( chanceBd[i], 1,0 )     => float bdSwitch;
    floatChance( chanceSd[i], 1,0 )     => float sdSwitch;
    floatChance( chanceHh[i], 1,0 )     => float hhSwitch;
    bd.keyOff();
    sd.keyOff();
    hh.keyOff();
    if( bdSwitch == 1 ){ bd.keyOn(); 1.0 => bdImpulse.next;  }
    if( sdSwitch == 1 ){ sd.keyOn(); }
    if( hhSwitch == 1 ){ hh.keyOn(); }
    beat => now;
    i++;
  }
}

fun void playBass()
{
  0 => int i;
  while(true)
    {
      floatChance( chanceBass[i], 1,0 )   => float bassSwitch;
      chanceBassNotes[Math.random2(0, 15)]    => float bassNote;
      bass.keyOff();
      if( bassSwitch == 1 ){ Std.mtof( bassNote + root ) => saw.freq; bass.keyOn();  }
      beat  => now;
      i++;
    }
}

fun void playMelody()
{
  0 => int i;
  while(true)
  {
    // TODO:
    // si la nota suena para cada step hay una curva de probabilidades que suene determinado intervalo.
    // hago un array de 100 que se va sobreescribiendo en cada step llenandolo de los valores dados por las posiciones y llena cuantos indica la probabilidad.
    //for( 0 => int j; j < 16; j++)
    // {
    // for(0 => int k; k < 100; k++)
    // {
    //  floatChance( chanceMelodyNote[i][j],j,noteSelectionArray[j]) =>  noteSelectionArray[k];
    //    <<< noteSelectionArray[k] >>>;
    // }
    // }
    [0.0,0,0,0,0,0,0,3,3,3,5,5,5,12,12,14,14,14,14,15,15,17,17,24,7,3,-12] @=> float noteSelectionArray[]; // probabilidad fija :(  TODO variar la probabilidad según la posición del step
    floatChance( chanceMelody[i], 1,0 ) => float melodySwitch;
    melody1.keyOff();
    if( melodySwitch == 1 )
    {
      //floatChance( chanceMelodyNote[0][0], floatChance(chanceMelodyNote[i][i],i,0),0) => float melodyNote;
      //floatChance( chanceMelodyNote[0][0], 0,1) => float melodyNote;
      noteSelectionArray[Math.random2(0, noteSelectionArray.cap()-1)] => float melodyNote;
      // asigna la frecuencia y enciende la envolvente
      Std.mtof( melodyNote + root + 24 ) => sin1.freq; melody1.keyOn();
    }
    // suena la nota
    beat => now;
    i++;  
  }
}

// llama funciones
//spork~ playDrums();
//spork~ playBass();
//spork~ playMelody();

// vive un tiempo
beat*16 => now;
// antes de morir  se crea  a sí mismo
Machine.add(me.dir() + "/gen_agitation_002.ck");

220::ms => dur beat;
36 => int root;

// cadena de audio -- drums
Gain master => dac;
// instrumentos
// --bassDrum 
Impulse bdImpulse => ResonZ bdFilter => ADSR bd => master;
1000 => bdImpulse.gain; bdFilter.set(50.0, 10.0); bd.set( 1::ms, 150::ms, .50, 100::ms );
// --snareDrum
Noise sdImpulse => ResonZ sdFilter => ADSR sd => master;
0.7 => sdImpulse.gain; sdFilter.set(400.0, 1.0); sd.set( 0::ms, 100::ms, .01, 100::ms );
// --hiHat
Noise hhImpulse => ResonZ hhFilter => ADSR hh => master;
0.2 => float hhGain; // asignamos esta variable para afectarla en la función
hhGain => hhImpulse.gain; hhFilter.set(10000.0, 5.0); hh.set( 0::ms, 50::ms, .01, 10::ms );

// --bass
SqrOsc saw => ADSR bass => LPF filterBass => dac;
0.15 => saw.gain;  800 => filterBass.freq;
bass.set( 0::ms, 80::ms, saw.gain()/1.5, 100::ms );
// --Melody
BlitSaw sin1 => ADSR melody1 => NRev melodyReverb => dac;
0.35 => sin1.gain;
melody1.set( 0::ms, 80::ms, saw.gain()/1.5, 100::ms );
0.03 => melodyReverb.mix;

/*
---------- Floor---------------
TODO: debe permitir cambiar de estados globales según tres estados
expo, buildUp, y drop
*/

// función generar probabilidades según corpus
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

// ============= DRUMS =================
// Probabilidad de un corpus -- drums
[100,  0,  0, 0,100,  0, 10,  0,100,  0,  0,  0,100,  0,  0, 20] @=> int chanceBd[]; 
[  0,  0,100, 0, 00,  0,100,  0,  0,  0,100,  0, 00,  0,100,  0] @=> int chanceSd[];
[ 100, 0,100,100,100, 0,100,100, 90,  0,100,100, 80,  0,100, 50] @=> int chanceHh[];

// curva de dinámica fija
[1.0,1.0,0.4,0.8,1.0,1.0,0.4,0.8,1.0,0.7,0.4,0.8,1.0,1.0,0.4,0.8] @=> float dynamicsFixed[];

// función que usa probabilidades para activar los instrumentos
fun void playDrums()
{
  0 => int i;
  while(true)
  {
    hhGain * dynamicsFixed[i] => hhImpulse.gain; // comente y descomente esta línea para escuchar la diferencia
    floatChance( chanceBd[i], 1,0 ) => float bdSwitch;
    floatChance( chanceSd[i], 1,0 ) => float sdSwitch;
    floatChance( chanceHh[i], 1,0 ) => float hhSwitch;
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

// ========== BASS ===========================
[ 100,  0, 0, 3, 100,  0, 100, 0, 100,  5, 0 ,  3, 100,  5, 100,  0] @=> int chanceBass[];
[  12,  0,  0, 0,  3,  3,  7,  3,  12,   0, 10, 12, 3,  0,  7, 0] @=> int chanceBassNotes[];
fun void playBass()
{
  0 => int i;
  while(true)
    {
      floatChance( chanceBass[i], 1,0 )   => float bassSwitch;
      chanceBassNotes[Math.random2(0, 15)]    => float bassNote;
      bass.keyOff();
      if( bassSwitch == 1 ){ Std.mtof( bassNote + root ) => saw.freq; bass.keyOn();  }
      beat => now;
      i++;
    }
}

// ========== Melody ============
SinOsc sine => ADSR eSine => dac;
0.03 => sine.gain;
eSine.set( 10::ms, 150::ms, .3, 10::ms );

// dos estados posibles:
[0.0,12.0] @=> float octaveStates[];

[[0.0,0.5],
 [1.0,0.5]] @=> float transitionMatrix[][];

// estado actual solo se usa al iniciar
12.0 => float currentState;

fun void playMarkov()
{
  while(true)
  {
    // recorre la cantidad de estados posibles
    for( 0 => int i; i < octaveStates.cap(); i++)
    {
      eSine.keyOff();
      if( currentState == octaveStates[i] )
      {
        (transitionMatrix[i][i] * 100.0) $ int => int percent;
        floatChance( percent,octaveStates[0],octaveStates[1] ) => currentState;
        Std.mtof(root + 24 + currentState) => sine.freq;
        eSine.keyOn();
        <<< currentState >>>;
        beat => now;
      }
    }
  }
}

spork~ playDrums();
spork~ playBass();
spork~ playMarkov();
// mantiene vivos los sporks
beat * 16 => now;
// antes de morir se crea a sí mismo
Machine.add(me.dir()+"/liveCode.ck"); 






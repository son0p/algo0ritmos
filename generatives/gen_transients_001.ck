

// define tempo
220::ms => dur beat;
16 * beat => dur loop;

36 => int root;

// Probabilidad de un corpus
[100,  0,  0, 0,100,  0, 10,  0,100,  0,  0,  0,100,  0,  0, 20] @=> int chanceBd[]; 
[  0,  0,  0, 0,100,  0,  0,  0,  0,  0,  0,  0,100,  0,  0, 15] @=> int chanceSd[];
[  0,  0,100, 0,  0,  3,100,  0,  5,  5,100,  3,  0,  0,100, 20] @=> int chanceHh[];
[100,  0,100, 0,100,  3,100, 15,100,  5,100,  3,100,  5, 90,  3] @=> int chanceBass[];
[  0,  0,  0, 0,  0,  3,  3,  3,  7,  0, 10, 12, 24,  0,  0, -2] @=> int chanceBassNotes[];

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
StifKarp  pluck => ADSR bPluck => dac;
0.09 => pluck.gain;
1 => pluck.pluck;
0 => pluck.pickupPosition;
bPluck.set( 0::ms, 800::ms, pluck.gain(), 100::ms );
SinOsc sin  => ADSR bSine => dac;
0.15 => sin.gain;
bSine.set( 0::ms, 800::ms, sin.gain(), 100::ms );

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
      bPluck.keyOff();
      bSine.keyOff();
      if( bassSwitch == 1 )
      {
        Std.mtof( bassNote + root ) => sin.freq; bSine.keyOn();
        Std.mtof( bassNote + root ) => pluck.freq; bPluck.keyOn();
      }
      beat => now;
      i++;
    }
}

0 => int i;
fun void playTransients()
{
  while(true)
  {
    1 => pluck.pluck;
    i/1000.0 => pluck.pickupPosition; 
    1 => pluck.sustain;
    beat => now;
    i++;
  }
}

// llama funciones
spork~ playDrums();
spork~ playBass();
spork~ playTransients();


// vive un tiempo
loop => now;
// antes de morir  se crea  a sí mismo
Machine.add(me.dir() + "/gen_transients_001.ck");

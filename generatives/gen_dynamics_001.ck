// define tempo
120::ms => dur beat;

// Probabilidad de un corpus
[100,  0,  0, 0,100,  0, 10,  0,100,  0,  0,  0,100,  0,  0, 20] @=> int chanceBd[]; 
[  0,  0,  0, 0,100,  0,  0,  0,  0,  0,  0,  0,100,  0,  0, 15] @=> int chanceSd[];
[  80, 0,100, 0, 80,  3,100,  0, 90,  5,100,  3, 80,  0,100, 50] @=> int chanceHh[];

// curva de dinámica fija
[1.0,1.0,0.4,0.8,1.0,1.0,0.4,0.8,1.0,0.7,0.4,0.8,1.0,1.0,0.4,0.8] @=> float dynamicsFixed[];


// cadena de audio
Gain master => dac;
// instrumentos
// --bassDrum 
Impulse bdImpulse => ResonZ bdFilter => ADSR bd => master;
1000 => bdImpulse.gain;
bdFilter.set(50.0, 10.0);
bd.set( 1::ms, 150::ms, .50, 100::ms );
// --snareDrum
Noise sdImpulse => ResonZ sdFilter => ADSR sd => master;
0.7 => sdImpulse.gain;
sdFilter.set(400.0, 1.0);
sd.set( 0::ms, 50::ms, .1, 100::ms );
// --hiHat
Noise hhImpulse => ResonZ hhFilter => ADSR hh => master;
0.5 => float hhGain; // asignamos esta variable para afectarla en la función
hhGain => hhImpulse.gain;
hhFilter.set(10000.0, 5.0);
hh.set( 0::ms, 50::ms, .1, 100::ms );

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

// llama funciones
spork~ playDrums();

// vive un tiempo
beat*16 => now;
// antes de morir  se crea  a sí mismo
Machine.add(me.dir() + "/gen_dynamics_001.ck");

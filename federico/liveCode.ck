BPM.sync(180.00) => BPM.tempo => dur beat;16 => BPM.steps; Generator generator;PlayerDrums dr;PlayerMelodies melodier;PlayerBass bassist;MelodyGenerator ml;Player play;ProgressionGenerator prog;Synth synth;SynthBass synthBass;CollectionBeats beats;CollectionMelodies melodies;CollectionBasses basses; CollectionProbabilities collectionProbabilities; Moodizer moodizer;Modulator modulator;
0 => CollectionProbabilities.probabilityOffset; // max 80
0 => int counter;
48 =>  BPM.root;
6 => ModesClass.modeNumber;

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

//--------------- Modulate effects
fun void fm(){while(true){1000 => synth.modulatorGain; 0.5 => synth.ratio; 100 => synthBass.modulatorGain;0.5 => synthBass.ratio; beat => now; }};
fun void delay(){while(true){0.99 => synth.delayGain;0.99 => synth.delayFeedback;beat => now;}}

spork~ dr.reverbTransformation(1);
//---------- nivel de variación---------
5 => dr.variationBDOffset;100 => dr.variationBDOnset;
5 => dr.variationSnOffset;100 => dr.variationSnOnset;
0 => dr.variationHHatOffset;100 => dr.variationHHatOnset;
//---------- Floor---------------
spork~ moodizer.dancefloor("a",1);

// -------- drums ---------





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

//test
function void testArrays(int arrayPosition)
{
  spork~ melodier.arrays(melodies.cumbia[arrayPosition]);
  spork~ bassist.arrays(basses.cumbia[arrayPosition]);
  spork~ dr.arrayDrums(beats.cumbia[arrayPosition]);
}

function void melodyIntegrated()
{
  while(true)
  {
    counter % 32 => int phrase;
    if (phrase == 0){ spork~ melodier.arrays(melodies.cumbia[1]); }
    if(phrase == 16){ spork~ melodier.arrays(melodies.cumbia[1]); }
    beat * 0.25  => now;
    counter++;
  }
}


// Modulation zone
function void bassModulator(int modulationGain, float ratio)
{
   modulationGain => synthBass.modulatorGain;
   ratio => synthBass.ratio;
}
// ensaye relaciones 0.38, 0.5, 1.0, 2.0, 4.0, 1.33333, 0.33333, 0.2857
spork~ bassModulator(50, 2.0);

function void melodyModulator(int modulationGain, float ratio)
{
  modulationGain => synth.modulatorGain;
  ratio => synth.ratio;
}
//spork~ melodyModulator(200, 0.5);
spork~ playDrums();
// mantiene vivos los sporks
beat * 8 => now;
// antes de morir se crea a sí mismo
Machine.add(me.dir()+"/liveCode.ck"); 






BPM.sync(180.00) => BPM.tempo => dur beat;16 => BPM.steps; Generator generator;PlayerDrums dr;PlayerMelodies melodier;PlayerBass bassist;Player play;Synth synth;SynthBass synthBass;CollectionBeats beats;CollectionMelodies melodies;CollectionBasses basses;Moodizer moodizer;Modulator modulator;0 => int counter;48 =>  BPM.root;

//--------------- Modulate effects
fun void fm(){while(true){1000 => synth.modulatorGain; 0.5 => synth.ratio; 100 => synthBass.modulatorGain;0.5 => synthBass.ratio; beat => now; }};
fun void delay(){while(true){0.99 => synth.delayGain;0.99 => synth.delayFeedback;beat => now;}}
spork~ delay();
//spork~ fm();
//spork~ modulator.close(1.0); //10.0 slow 0.2 fast
//--------alteraciones notas-----------
//spork~ dr.reverbTransformation(2);
spork~ dr.reverbTransformation(1);
//---------- nivel de variación---------
5 => dr.variationBDOffset;100 => dr.variationBDOnset;
5 => dr.variationSnOffset;100 => dr.variationSnOnset;
0 => dr.variationHHatOffset;100 => dr.variationHHatOnset;
//---------- Floor---------------
spork~ moodizer.dancefloor("b",2);
//spork~ moodizer.dancefloor("c",2);
// ------- Live
[[[0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[1,0,0,1,0,1,1,1,0,1,1,1,0,1,1,1]]]@=>  int liveBeat[][][];
[[[0.0,0,0],[.15, .15, .15, .15, .15, .15, .15, .15, .15, .15, .15, .15, .15, .15, .15],[0.0,2.0, 10.0 ]]]@=> float liveBass[][][];
[[[12.0, 12.0,12,12,12,  12, 12  ],[  .25,  .25,   .50, 1, .15, 1, .15 ],[0.0,2.0,  14.0, 16, 18, 24, 28  ]]]@=> float liveMel[][][];

////---------Live Arrays
// spork~ dr.arrayDrums(liveBeat[0]);
// spork~ bassist.arrays(liveBass[0]);
// spork~ melodier.arrays(liveMel[0]);

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

function void liveArrays()
{
    spork~ dr.arrayDrums(liveBeat[0]);
    spork~ bassist.arrays(liveBass[0]);
    spork~ melodier.arrays(liveMel[0]);//live
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
spork~ melodyModulator(200, 0.5);
// mantiene vivos los sporks
while( true ){
    100::ms => now;
}

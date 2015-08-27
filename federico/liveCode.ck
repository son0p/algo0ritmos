BPM.sync(180.00) => BPM.tempo => dur beat;16 => BPM.steps; Generator generator;PlayerDrums dr;PlayerMelodies melodier;PlayerBass bassist;MelodyGenerator ml;Player play;ProgressionGenerator prog;Synth synth;SynthBass synthBass;CollectionBeats beats;CollectionMelodies melodies;CollectionBasses basses;Moodizer moodizer;Modulator modulator;0 => int counter;48 =>  BPM.root;

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
//spork~ moodizer.dancefloor("b",2);
//spork~ moodizer.dancefloor("c",2);
// ------- Live
[[[0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[1,0,0,1,0,1,1,1,0,1,1,1,0,1,1,1]]]@=>  int liveBeat[][][];
[[[0.0,0,0],[.15, .15, .15, .15, .15, .15, .15, .15, .15, .15, .15, .15, .15, .15, .15],[0.0,2.0, 10.0 ]]]@=> float liveBass[][][];
[[[0.0, 0.0,12,12,12,  12, 12  ],[  .25,  .25,   .50, 1, .15, 1, .15 ],[0.0,2.0,  14.0, 16, 18, 24, 28  ]]]@=> float liveMel[][][];

// spork~ dr.arrayDrums(liveBeat[0]);
// spork~ bassist.arrays(liveBass[0]);
 spork~ melodier.arrays(liveMel[0]);

//------------------------------------------POOL-----------------------------------------------------

// mode probability

// [[[1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0]]]@=>  int liveBeat[][][];
// [[[0.0,1,2,3,4,5,6,7,12],[1.0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],[0.0,4,6,8,10,12,14,16,18 ]]]@=> float liveBass[][][];
// [[[24.0, 12.0,12,12,48,  12, 12  ],[  .25,  .25,   .50, 1, .15, 1, .15 ],[0.0,2.0,  8.0, 10, 14, 24, 28  ]]]@=> float liveMel[][][];

// function void bassIntegrated()
// {
//   0 => int counter;
//     while(true)
//   {
//     counter % 32 => int bassPhrase;
//     if(bassPhrase == 0){spork~ bassist.arrays(basses.cumbia[Math.random2(0,basses.cumbia.cap()-1)]);}
//     if(bassPhrase == 0){spork~ bassist.arrays(basses.cumbiaBuildUp[Math.random2(0,basses.cumbia.cap()-1)]);}
//      if(bassPhrase == 0){spork~ bassist.arrays(basses.cumbiaDrop[Math.random2(0,basses.cumbia.cap()-1)]);}

//     beat * 1 => now;
//     counter++;
//  }
// }

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

//spork~ build();
//spork~ drop();


//spork~ dr.arrayDrums(liveBeat[0]);
//spork~ BPM.metro(8, beat);
//spork~ dr.arrayDrums(beats.cumbia[0]);

//spork~ bassist.arrays(liveBass[0]);
//spork~ bassIntegrated();


//spork~ melodier.arrays(liveMel[0]);//live
//spork~ melodyIntegrated();



//spork~ dr.fill(5, 0.125);
//spork~ melodier.arrays(melodies.base[1]);
//spork~ melodier.arrays(liveMel[0]);
//spork~ play.chordPlayer(test,1);
//spork~ synth.playChord([57,60,64], 1, 0);
//spork~ play.chordPlayer([[57,60,64], [57,63,67], [80, 84, 88]]);
//spork~ play.playMelody(1, root, 3, [[(test[0]),2],[test(1),1]]);
//spork~ play.playMelody(1, root, 3, [[0,1],[3,1]]);
//spork~ play.playMelody(1, root, 3, [[0,2],[4,1],[2,2],[0,1],[-88,1],[6,1],[-88,1]]);
//spork~ ml.searchMelody( root,6,4, 8);
//spork~ ml.generateMelody(root,2);


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

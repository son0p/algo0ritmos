BPM.sync(120.00) => BPM.tempo => dur beat;
16 => BPM.steps;
Generator generator;
PlayerDrums dr;
PlayerMelodies melodier;
PlayerBass bassist;
MelodyGenerator ml;
Player play;
ProgressionGenerator prog;
Synth synth;
CollectionBeats beats;
CollectionMelodies melodies;
CollectionBasses basses;

50 =>  BPM.root;
SawOsc bass => Envelope e => NRev r =>   dac;
0.05 => bass.gain;
0.03 => r.mix;

function void printMetro4()
{
    while(true)
   {
       BPM.metro();
       <<<BPM.metro4, "">>>;
       BPM.tempo/4 => now;
   }
}
0 => int counter;

[[
[0.0, 3, 5, 7, 10, 5, 7, 10],
[.25,.25, .25, .25, .25, .25, .25, .25],
[0.0, 2, 4, 6, 9, 10, 12, 14]
]]@=> float liveMel[][][];

[[
[0.0,  0,  0,   0,    0,   0,   0,   0],
[.25, .25, .25, .25, .25, .25, .25, .25],
[0.0,  2,  4,   6,    8,   10,   12, 14]
]]@=> float liveBass[][][];



spork~ printMetro4();
//spork~ dr.reverbTransformation(1);
spork~ dr.soundTransformation();
//spork~ dr.fill(5, 0.125);
spork~ dr.arrayDrums(beats.base[1]);
//spork~ melodier.arrays(melodies.base[1]);
spork~ melodier.arrays(liveMel[0]);
//spork~ bassist.arrays(basses.base[0]);
spork~ bassist.arrays(liveBass[0]);

//spork~ play.chordPlayer(test,1);
//spork~ synth.playChord([57,60,64], 1, 0);
//spork~ play.chordPlayer([[57,60,64], [57,63,67], [80, 84, 88]]);
//spork~ play.playMelody(1, root, 3, [[(test[0]),2],[test(1),1]]);
//spork~ play.playMelody(1, root, 3, [[0,1],[3,1]]);
//spork~ play.playMelody(1, root, 3, [[0,2],[4,1],[2,2],[0,1],[-88,1],[6,1],[-88,1]]);
//spork~ ml.searchMelody( root,6,4, 8);
//spork~ ml.generateMelody(root,2);


// DEBUG zone

while( true ){
    1000::ms => now;
}

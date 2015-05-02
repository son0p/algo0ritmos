BPM.sync(80.00) => BPM.tempo => dur beat;
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

28 =>  BPM.root;
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


//prog.genProg((root+24),0) @=> int test[][];
//prog.readProg((root+24), "m", [6,5,0,0]) @=> int test[][];

spork~ printMetro4();
//spork~ dr.reverbTransformation(1);
spork~ dr.soundTransformation();
//spork~ dr.fill(5, 0.125);
spork~ dr.arrayDrums(beats.beyonce[0]);
spork~ melodier.arrays(melodies.base[1]);

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

BPM.sync(90.00) => BPM.tempo => dur beat;
Generator generator;
Drummer dr;
MelodyGenerator ml;
Player play;
ProgressionGenerator prog;
Synth synth;

28 => int root;
SawOsc bass => Envelope e => NRev r =>   dac;
0.05 => bass.gain;
0.03 => r.mix;

function void printMetro4()
{
    while(true)
   {
       <<<BPM.metro4, "">>>;
       BPM.tempo/4 => now;
   }
}

fun void bs()
{
	while(true)
	{
		[0,0,0,0,0,0,0,0,0,0,12,12,48] @=> int seed[];
		seed[(Math.random2(0, seed.cap()-1))] => int octa;
        beat /2 => now;
	    Std.mtof(root) => bass.freq; e.keyOn(); beat/4 => now; e.keyOff();
		Std.mtof(root+12) => bass.freq; e.keyOn(); beat/4 => now; e.keyOff();
    }
}

0 => int counter;
fun void mel()
{
   // 0 => int counter;

    int notes[16];
    float duration[16];
    [12, 12, 12, 12, 12] @=> int insertNotes[];
    [0.10, 0.10, 0.10, 0.10, 0.10] @=> float insertDuration[];
    [0, 4, 8, 12] @=> int position[];
    for(0 => int i; i < position.cap(); i++)
    {
        insertNotes[i] => notes[position[i]];
        insertDuration[i] => duration[position[i]];
       // <<< notes[i]>>>;
    }
    while(true)
    {
        counter % 16 => int metro4;
        if(metro4 ==  0 || metro4 == 8)
        {
            <<< "note", metro4>>>;
            //<<< notes[metro4],"tt">>>;
            doPlay(notes[metro4], duration[metro4]);
        }
        //<<< metro4 >>>;
        BPM.tempo / 4 => now;
        counter++;
    }

}

function void doPlay(int notes, float duration)
{
    synth.playNote(root + 48 + notes, duration);
}

//prog.genProg((root+24),0) @=> int test[][];
prog.readProg((root+24), "m", [6,5,0,0]) @=> int test[][];

fun void toneKick()
{
	generator.percentChance(1,1) => dr.toneSustain;
	beat => now;
}
//spork~ toneKick();

FavoriteBeats favorites;

//spork~ BPM.metro();
//spork~ printMetro4();
// vopy aca, no quiero poder actualizar los loops pero aun no lo logro
//spork~ dr.reverbTransformation(1);
//spork~ dr.soundTransformation();
//spork~ dr.fill(5, 0.125);
spork~ dr.arrayDrums(favorites.base[0]);
//spork~ dr.hh();
//spork~ dr.sn();
// spork~ dr.bi(3, 4);
//spork~ bs();
spork~ mel();


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

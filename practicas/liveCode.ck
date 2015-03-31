// 9:06 err> * * *

//bpm.changeTempo(120) => dur beat;

714::ms => dur beat;

// Instanciar Clases
//BPM bpm;
// FIX: me asignar un valor arriba primero para que funcione
// debería poderse asignar acá directament
BPM.sync(80.00) => BPM.tempo => beat;
Generator generator;
Drummer dr;
MelodyGenerator ml;
Player play;
ProgressionGenerator prog;

28 => int root;


SawOsc bass => Envelope e => NRev r =>   dac;
0.05 => bass.gain;
0.03 => r.mix;

fun void bs(){
	while(true)
	{
		[0,0,0,0,0,0,12,12,48,96] @=> int seed[];
		seed[(Math.random2(0, seed.cap()-1))] => int octa;
		beat /2 => now;
		Std.mtof(root) => bass.freq; e.keyOn(); beat/4 => now; e.keyOff();
		Std.mtof(root+12) => bass.freq; e.keyOn(); beat/4 => now; e.keyOff();
	}
}

fun void mel()
{
	beat => now;
}



//prog.genProg((root+24),0) @=> int test[][];
prog.readProg((root+24), "m", [6,5,0,0]) @=> int test[][];
Synth synth;

fun void toneKick(){
	generator.percentChance(1,1) => dr.toneSustain;
	beat => now;
}
spork~ toneKick();

FavoriteBeats favorites;


// vopy aca, no quiero poder actualizar los loops pero aun no lo logro
//spork~ dr.reverbTransformation(1);
spork~ dr.soundTransformation();
spork~ dr.fill(5, 0.125);
spork~ dr.arrayDrums(favorites.beyonce[1]);
//spork~ dr.hh();
//spork~ dr.sn();
// spork~ dr.bi(3, 4);
//spork~ bs();


//spork~ play.chordPlayer(test,1);
//spork~ synth.playChord([57,60,64], 1, 0);
//spork~ play.chordPlayer([[57,60,64], [57,63,67], [80, 84, 88]]);
//spork~ play.playMelody(1, root, 3, [[(test[0]),2],[test(1),1]]);
//spork~ play.playMelody(1, root, 3, [[0,0],[3,0]]);
//spork~ play.playMelody(1, root, 3, [[0,2],[4,1],[2,2],[0,1],[-88,1],[6,1],[-88,1]]);
//spork~ ml.searchMelody( root,6,4, 8);
//spork~ ml.generateMelody(root, 2);


// DEBUG zone

while( true ){
    beat => now;
}

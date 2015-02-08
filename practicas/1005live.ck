// 9:06 err> * * *
714::ms => dur beat;
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

Drummer dr;
MelodyGenerator ml;
Player play;
ProgressionGenerator prog;
//prog.genProg((root+24),0) @=> int test[][];
prog.readProg((root+24), "m", [6,5,0,0]) @=> int test[][];
Synth synth;

FavoriteBeats favorites;
favorites.fav1[0] @=> int pattern1[][];
	
// vopy aca, no quiero poder actualizar los loops pero aun no lo logro

spork~ dr.arrayDrums(pattern1);
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




while( true ){ beat => now; }
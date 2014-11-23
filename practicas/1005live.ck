// 9:06 err> * * *
500::ms => dur beat;
28 => int root;

SawOsc bass => Envelope e => NRev r => dac;
0.1 => bass.gain;
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
 spork~ dr.kk(1,1);
 spork~ dr.hh();
 spork~ dr.sn();
// spork~ dr.bi(3, 4);
 spork~ bs();


spork~ play.playMelody(3, root, 3, [[7,2],[4,2],[0,2],[0,1],[0,1],[6,1],[0,1]]);
//spork~ ml.searchMelody(root, 1, 2);
//spork~ ml.generateMelody(root, 2);



while( true ){ beat => now; }
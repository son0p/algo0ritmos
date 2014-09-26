// 9:06 err> * * *
500::ms => dur beat;
28 => int root;

SawOsc bass => Envelope e => NRev r => dac;
0.1 => bass.gain;
0.3 => r.mix;

fun void bs(){
	while(true){
		[0,0,0,0,0,0,12,12,48,96] @=> int seed[];
		seed[(Math.random2(0, seed.cap()-1))] => int octa;
		Std.mtof(root+octa) => bass.freq; e.keyOn(); beat/2 => now; e.keyOff(); beat/2;
		Std.mtof(root+12) => bass.freq; e.keyOn(); beat/2 => now; e.keyOff(); beat/2;
}
}

Drummer dr;
//spork~ dr.kk(1,4);
//spork~ dr.hh();
//spork~ dr.sn();
//spork~ dr.bi(3, 4);
//spork~ bs();

while( true ){ beat => now; }
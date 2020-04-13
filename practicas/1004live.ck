// 6>36  *1 *1 *1 *1 6>50
500::ms => dur bit;

28 => int root;

SawOsc bass => Envelope e => dac;
TriOsc mel => Envelope f => NRev r =>dac; 
0.1 => bass.gain;
0.05 => mel.gain;
0.3 => r.mix;

fun void bs()
{
	while( true )
	{
		//[0,0,0,0,0,0,12,12,24,48,96] @=> int seed[];
		//seed[Math.random2(0, seed.cap()-1)] => int octa;
		1 => int octa;
		Std.mtof(root+octa) => bass.freq; e.keyOn(); bit/2 => now; e.keyOff();
		Std.mtof(root+12) => bass.freq; e.keyOn(); bit/2 => now; e.keyOff();
	}
}


Drummer dr;
spork~ dr.kk(1, 1);
spork~ dr.hh();
spork~ dr.sn();
spork~ dr.bi(3, 0);
spork~ bs();


while( true ){ bit => now; }
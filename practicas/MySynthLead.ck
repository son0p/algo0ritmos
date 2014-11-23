// ==============================================================================
// PUBLIC CLASS: MySynthLead
// File        : MySynthLead.ck
// Author      : son0p
// Init Date   : 2014-Nov-23
// Dependencies: 
// License     :
// Git repo    : https://github.com/son0p/ChucK-classes-and-patches
// ==============================================================================
// This class takes an array of notes and play it
500::ms => dur beat;
public class MySynthLead
{
	KBHit kb;
	SqrOsc mel => Envelope e =>  NRev r => HPF HPfilter => LPF LPFilter => dac;
	0.05 => mel.gain;
	0.1 => r.mix;
	20000 => LPFilter.freq;
	
//	static int root;
//	int number;

//	int notes[];
	fun void test()
	{
	<<< "test ok" >>>;	
	}
	
	fun void playNote( int root, int octave,  int note, dur duration )
	{
		// Dependiendo de la octava se ajusta el valor para
		// sumarlo a la nota seleccionada.
		if( octave == 1) octave + 11 => octave;
		if( octave == 2) octave + 22 => octave;
		if( octave == 3) octave + 33 => octave;
		if( octave == 4) octave + 44 => octave;
		if( octave == 5) octave + 55 => octave;
		0 => int i;
	
			Math.random2f(104,4000) => HPfilter.freq;
			0.5 => HPfilter.Q;
			Std.mtof( root + note + octave ) => mel.freq;
			e.keyOn();
			duration => now;
			e.keyOff();
		}
}
	



	
	
	

// ==============================================================================
// Test code



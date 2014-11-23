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

	fun void playNote( int soundType, int root, int octave,  int note, dur duration )
	{
		Std.mtof( root + note + octave ) => float freq;
		if( soundType == 1)
		{
			one(freq, duration);
		}
		if( soundType == 2)
		{
			two(freq, duration);
		}
		if( soundType == 3)
		{
			three(freq, duration);
		}
		if( soundType == 4)
		{
			four(freq, duration);
		}
		if( soundType == 5)
		{
			five(freq, duration);
		}
	
	}
	
	// Filter lead synth sounType 1
	fun void one(float freq, dur duration)
	{
		SinOsc mel => Envelope e =>  NRev r => HPF HPfilter => LPF LPFilter => dac;
		freq => mel.freq;
		0.2 => mel.gain;
		0.2 => r.mix;
		20000 => LPFilter.freq;
		Math.random2f(100,200) => HPfilter.freq;
		0.5 => HPfilter.Q;
		e.keyOn();
		duration => now;
		e.keyOff();
	}
	fun void two(float freq, dur duration)
	{
		SqrOsc mel => Envelope e =>  NRev r => HPF HPfilter => LPF LPFilter => dac;
		freq => mel.freq;
		0.05 => mel.gain;
		0.2 => r.mix;
		20000 => LPFilter.freq;
		Math.random2f(104,4000) => HPfilter.freq;
		0.5 => HPfilter.Q;
		e.keyOn();
		duration => now;
		e.keyOff();
	}
	fun void three(float freq, dur duration)
	{
		SawOsc mel => Envelope e =>  NRev r => HPF HPfilter => LPF LPFilter => dac;
		freq => mel.freq;
		0.05 => mel.gain;
		0.2 => r.mix;
		20000 => LPFilter.freq;
		Math.random2f(104,4000) => HPfilter.freq;
		0.5 => HPfilter.Q;
		e.keyOn();
		duration => now;
		e.keyOff();
	}
	fun void four(float freq, dur duration)
	{
		TriOsc mel => Envelope e =>  NRev r => HPF HPfilter => LPF LPFilter => dac;
		freq => mel.freq;
		0.05 => mel.gain;
		0.2 => r.mix;
		20000 => LPFilter.freq;
		Math.random2f(104,4000) => HPfilter.freq;
		0.5 => HPfilter.Q;
		e.keyOn();
		duration => now;
		e.keyOff();
	}
	fun void five(float freq, dur duration)
	{
		SqrOsc mel => Envelope e =>  NRev r => HPF HPfilter => LPF LPFilter => dac;
		freq => mel.freq;
		0.05 => mel.gain;
		0.2 => r.mix;
		20000 => LPFilter.freq;
		Math.random2f(104,4000) => HPfilter.freq;
		0.5 => HPfilter.Q;
		e.keyOn();
		duration => now;
		e.keyOff();
	}

}
	
	

// ==============================================================================
// Test code



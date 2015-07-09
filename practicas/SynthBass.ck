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
BPM.beat(1) => dur beat;
public class SynthBass
{
	SqrOsc chords[4]; // TODO > This must be dynamic
	Gain master => Envelope e => NRev rev =>dac;
	// Gain master => dac;
	0.1 => master.gain;
	0.05 => rev.mix;
	for(0=> int i; i < chords.cap(); i++)
	{
		// use array to chuck unit genenrator to MASTER
		chords[i] =>  master;
	}

 	KBHit kb;

	fun void playNote( float note, float duration )
	{
		Std.mtof( note ) => float freq;
		SqrOsc mel => Envelope e =>  NRev r => HPF HPfilter => LPF LPFilter => dac;
        SinOsc sine => Envelope eSine => NRev rSine => dac;
		freq*2 => mel.freq; freq => sine.freq;
		0.02 => mel.gain; 0.09 => sine.gain;
		0.03 => r.mix; 0.03 => rSine.mix;
		20000 => LPFilter.freq;
		20 => HPfilter.freq;
		0.5 => HPfilter.Q;
		e.keyOn(); eSine.keyOn();
		beat*duration => now;
		e.keyOff();eSine.keyOff();
	}

    	fun void playNote( int note, dur duration, int soundType )
	{
		Std.mtof( note ) => float freq;
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

	// Filter lead synth soundType 1
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

	fun void playChord( int notes[], int div, int voices)
	{
		// play chord
		for( 0 => int i; i < notes.cap(); i++)
		{
			Std.mtof(notes[i]) => chords[i].freq;
		}
		e.keyOn();
		beat/div => now;
		e.keyOff();
		// reset
		for( 0=> int i; i < chords.cap(); i++)
		{
			0=> chords[i].freq;
		}
	}
}


// ==============================================================================
// Test code

// Synth mySynth;
// [60, 63, 66] @=> int test[];
// mySynth.playChord(test, 1, 1);

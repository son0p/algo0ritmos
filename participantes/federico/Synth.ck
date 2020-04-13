// ==============================================================================
// PUBLIC CLASS: Synth
// File        : Synth.ck
// Author      : son0p
// Init Date   : 2014-Nov-23
// Dependencies:
// License     :
// Git repo    : https://github.com/son0p/ChucK-classes-and-patches
// ==============================================================================
// This class takes an array of notes and play it
BPM.beat(1) => dur beat;
public class Synth
{
    // Initialize FM
    SqrOsc  modulator;
    SinOsc  carrier;
    100 => static int modulatorGain;
    2 => carrier.sync;
    0.05 =>  carrier.gain;
    0.5 => static float ratio;
    // Inicializo efectos y filtros
    NRev reverb;
    Delay delay;
    Gain feedback;
    (beat*2)/3 => delay.max => delay.delay;
    0.3 => static float delayGain => delay.gain;
    0.5 =>  static float delayFeedback => feedback.gain;
    HPF HPFilter;
    LPF LPFilter;
    0.02 => reverb.mix;
    20000 => LPFilter.freq;
	0.2 => HPFilter.Q;
    50 => HPFilter.freq;
    // Gain
	Gain master => dac;
    static float synthGain;
	0.5=> synthGain => master.gain;
    ADSR envelope;
    envelope.set( 5::ms, 8::ms, .5, 50::ms);
    // Audio chain
    modulator => carrier => envelope => reverb => master;
    master =>  feedback => delay => master;

	fun void playNote( float note, float duration )
	{
		Std.mtof( note ) => float freq;
        freq * ratio => modulator.freq;
        modulatorGain => modulator.gain;
        freq => carrier.freq;
		envelope.keyOn();
		beat*duration => now;
		envelope.keyOff();
        delayGain => delay.gain;
        delayFeedback => feedback.gain;
	}
}

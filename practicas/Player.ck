// ==============================================================================
// PUBLIC CLASS: Player
// File        : Player.ck
// Author      : son0p
// Init Date   : 2014-Nov-23
// Dependencies: MySinthLead.ck
// License     :
// Git repo    : https://github.com/son0p/ChucK-classes-and-patches
// ==============================================================================
// This class takes an array of notes and send it to a synth
500::ms => dur beat;
//lead.test();

public class Player
{
	fun void playMelody( int root, int octave,  int notes[][] )
	{
		MySynthLead lead;
	
		// Dependiendo de la octava se ajusta el valor para
		// sumarlo a la nota seleccionada.
		if( octave == 1) octave + 11 => octave;
		if( octave == 2) octave + 22 => octave;
		if( octave == 3) octave + 33 => octave;
		if( octave == 4) octave + 44 => octave;
		if( octave == 5) octave + 55 => octave;
		0 => int i;
		while( true )
		{
			i % 8 => int i8;
			if ( notes [i8][0] != 0 )
			{
				<<< notes [i8][0] >>>;
				beat/( notes[i8][1]) => dur duration;
				// actually play thru MySynthLead class
				lead.playNote(root, octave, notes[i8][0], duration);
				beat/( notes[i8][1] ) => now;
				
			}
			if ( notes [i8][0] == 0 )
			{
				beat/( notes[i8][1] ) => now;
			}
			i++;
		}
	}
}

// ==============================================================================
// Test code



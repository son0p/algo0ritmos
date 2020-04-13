// ==============================================================================
// PUBLIC CLASS: Player
// File        : Player.ck
// Author      : son0p
// Init Date   : 2014-Nov-23
// Dependencies: Synth.ck
// License     :
// Git repo    : https://github.com/son0p/ChucK-classes-and-patches
// ==============================================================================
// This class takes an array of notes and send it to a synth

BPM.tempo => dur beat;

public class Player
{
	fun void playMelody( int soundType, int root, int octave,  int notes[][] )
	{
		Synth lead;

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
			if ( notes [i8][0] != -88 )
			{
				<<< notes [i8][0] >>>;
				beat/( notes[i8][1]) => dur duration;
				// actually play thru Synth class
			//	lead.playNote(soundType, root, octave, notes[i8][0], duration);
				beat/( notes[i8][1] ) => now;

			}
			if ( notes [i8][0] == -88 )
			{
				beat/( notes[i8][1] ) => now;
			}
			i++;
		}
	}

	fun void chordPlayer(int chords[][], int div)
	{
		Synth mySynth;
	//	[57,60,65] @=> int chord[];


		while( true )
		{
			//mySynth.playChord(chord,1,1); // TODO Duration and preset dynamic

			for( 0 => int i; i < chords.cap(); i++)
			{
			//	mySynth.playChord(chords[i], 1, 3);
				beat/div => now; 			// TODO Duration must be dynamic
			}

		}
	}
}

// ==============================================================================
// Test code
// pre-load Machine.add(me.dir()+"/Synth.ck");

// Player player;
//  [[57,60,64],[57,60,65]] @=> int chords[][];
//  player.chordPlayer(chords);

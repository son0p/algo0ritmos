// ==============================================================================
// PUBLIC CLASS: MelodyGenerator
// File        : MelodyGenerator.ck
// Author      : son0p
// Init Date   : 2013-Dec-31
// Dependencies: Mode.ck
// License     :
// Git repo    : https://github.com/son0p/ChucK-classes-and-patches
// ==============================================================================
// This class takes root note and mode then returns a melody

public class MelodyGenerator
{
	static int root;
	int number;

	int notes[];

	// TODO: This must be :
	// int melody[notes.cap()];
	// but produces NullPointerException
	int melody[8];

	[2,2,2,2,2,4,4,4,4,8,16] @=> int durations[];

	// initialize new note to be compared in rules
	root => int oldNote;
	int pushNote;
	Mode mode;
	int motive[7];

	fun int[] generateMelody(int root, int modeInput)
	{
		// Ask for notes to  Mode class
		mode.generateMode(root, modeInput) @=> int notes[];
		// <<< "Mode: ", modeInput >>>;

		// Go over Mode array to pushing notes that obey the rules 
		for	(0 => int i; i < melody.cap(); i++)
		{
			// Random choose for a note.
			Math.random2(1, notes.cap())-1 => int noteSelector;

			// Rule: Intervals of max 6 tones
			noteSelector => int newNote;
			if(newNote < (oldNote + 6))
			{
				notes[noteSelector] => int pushNote;
				// Fill the array with selected notes
				pushNote =>  melody[i];
			}
		}
		
		return melody;
	}
	
	// TODO : duration must fill a measure
	fun int generateDuration()
	{
		durations[(Math.random2(1, durations.cap())-1)] => int pushDuration;
		return pushDuration;
	}
	
}


// ==============================================================================
// Test code

/*
500::ms => dur beat;
MelodyGenerator m;

m.generateMelody(60,2);
beat/m.generateDuration(); => now;
*/
//===============================================================================



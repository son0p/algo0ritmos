// ==============================================================================
// PUBLIC CLASS: Mode
// File        : Mode.ck
// Author      : son0p
// Init Date   : 2013-Dec-31
// Dependencies: 
// License     :
// Git repo    : https://github.com/son0p/ChucK-classes-and-patches
// ==============================================================================
// This class takes root note and a mode, then returns an array of notes
// of a specific mode.

public class Mode
{
	//member variables
	int root;
	int modeInput;
	int notes[];
		
	fun int[] generateMode(int root, int modeInput)
	{
		// Ionian
		if ( modeInput == 1 )
		{
			[0, 2, 4, 5, 7, 9, 11, 12] @=> int notes[];
			return notes;
		}
		// Dorian
		if ( modeInput == 2 )
		{
			[0, 2, 3, 5, 7, 9, 10, 12] @=> int notes[];
			return notes;
		}
		// Phrygian
		if ( modeInput == 3 )
		{
			[0,  1,  3,  5,  7,   8,
			  10,   12] @=> int notes[];
			return notes;
		}
		// Lydian
		if ( modeInput == 4 )
		{
			[0,  2,  4,  6,  7,   9,
			  11,   12] @=> int notes[];
			return notes;
		}
		// Mixolidian
		if ( modeInput == 5 )
		{
			[0,  2,  4,  5,  7,   9,
			  10,   12] @=> int notes[];
			return notes;
		}
		// Aeolian
		if ( modeInput == 6 )
		{
			[0,  2,  3,  5,  7,   8,
			  10,   12] @=> int notes[];
			return notes;
		}
		// Locrian
		if ( modeInput == 7 )
		{
			[0,  1,  3,  5,  6,   8,
			  10,    12] @=> int notes[];
			return notes;
		}
		else
		{
			<<< "Please use modes between 1 - 7" >>>;
		}
		
		return notes;
	}
}

// ================================================================================
// Test code
/*
Mode mode;
mode.generateMode(60,7 ) @=> int notes[];
<<< notes >>>;
*/







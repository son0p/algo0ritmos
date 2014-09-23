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
		if (modeInput == 1)
		{
			[(root),(root + 2),(root + 4),(root + 5),(root + 7), (root + 9),
			(root + 11), (root + 12)] @=> int notes[];
			return notes;
		}
		// Dorian
		if (modeInput == 2)
		{
			[(root),(root + 2),(root + 3),(root + 5),(root + 7), (root + 9),
			(root + 10), (root + 12)] @=> int notes[];
			return notes;
		}
		// Phrygian
		if (modeInput == 3)
		{
			[(root),(root + 1),(root + 3),(root + 5),(root + 7), (root + 8),
			(root + 10), (root + 12)] @=> int notes[];
			return notes;
		}
		// Lydian
		if (modeInput == 4)
		{
			[(root),(root + 2),(root + 4),(root + 6),(root + 7), (root + 9),
			(root + 11), (root + 12)] @=> int notes[];
			return notes;
		}
		// Mixolidian
		if (modeInput == 5)
		{
			[(root),(root + 2),(root + 4),(root + 5),(root + 7), (root + 9),
			(root + 10), (root + 12)] @=> int notes[];
			return notes;
		}
		// Aeolian
		if (modeInput == 6)
		{
			[(root),(root + 2),(root + 3),(root + 5),(root + 7), (root + 8),
			(root + 10), (root + 12)] @=> int notes[];
			return notes;
		}
		// Locrian
		if (modeInput == 7)
		{
			[(root),(root + 1),(root + 3),(root + 5),(root + 6), (root + 8),
			(root + 10), (root + 12)] @=> int notes[];
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







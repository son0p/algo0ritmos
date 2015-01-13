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

500::ms => dur beat;



public class MelodyGenerator
{
	KBHit kb;
	SqrOsc mel => Envelope e =>  NRev r => HPF filter => dac;
	0.05 => mel.gain;
	0.1 => r.mix;
	
	static int root;
	int number;

	int notes[];
	int durations[32];
	// TODO: This must be :
	// int melody[notes.cap()];
	// but produces NullPointerException
	int melody[8];

	// initialize new note to be compared in rules
	root => int oldNote;
	int pushNote;
	int motive[7];

	fun int[] generateMelody(int root, int modeInput, int beats)
	{
		// Ask for notes to  Mode class
		generateMode(root, modeInput) @=> int notes[];
		
		// Go over Mode array to pushing notes that obey the rules 
		for	(0 => int i; i < beats; i++)
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
			if(newNote < (oldNote - 6))
			{
				notes[noteSelector] => int pushNote;
				// Fill the array with selected notes
				pushNote =>  melody[i];
			}
		}
			
		return melody;
	}
	
	// TODO : duration must fill a measure
	fun int[] generateDuration( int beats)
	{
		[1,1,1,2] @=> int seedDuration[]; 
		for( 0 => int i; i < (beats-1); i++)
		{
			seedDuration[(Math.random2(1, seedDuration.cap())-1)] => int pushDuration ;
			pushDuration => durations[i];
		}
			return durations;
	}
	
	fun void searchMelody(int root, int mode, int seed, int beats)
	{
		MelodyGenerator m;
		m.generateMelody((root+24), mode, beats) @=> int notes[];
//		m.generateDuration(beats) @=> int div[];
		[1,1,1,1] @=> int div[];
		
		0 => int i;

		while( true )
		{
			Math.random2f(200,1500) => filter.freq;
			Math.random2f(0.1, 0.9) => filter.Q;
			//1 => filter.Q;

			i % 8 => int iLoop;

			//div[i] => int div;
			
			if( notes[iLoop] > 0 )
			{
				Std.mtof( notes[iLoop] ) => mel.freq; e.keyOn(); beat/beats => now; e.keyOff();
			}
			if( notes[iLoop] <= 0 )
			{
				e.keyOff();
				beat/beats => now; 
			}
			i++;
		//	<<< ((notes[iLoop]) - root), i, notes.cap() >>>;
			
		}
	}
		fun void playMelody( int root, int octave,  int notes[][] )
		{
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
				//Math.random2f(40,4000) => filter.freq;
				100 => filter.Q;
				if ( notes [i8][0] != 0 )
				{
					Std.mtof( root + notes[i8][0] + octave ) => mel.freq; e.keyOn(); beat/( notes[i8][1] ) => now; e.keyOff();
					
			}
				if ( notes [i8][0] == 0 )
				{
					beat/( notes[i8][1] ) => now; e.keyOff();
				}
				i++;
			}
		}
	}

	fun int[] generateMode( int root, int modeInput )
	{
		int notes[];
		// Ionian
		if ( modeInput == 1 )
		{
			[(root),(root + 2),(root + 4),(root + 5),(root + 7), (root + 9),
			(root + 11), (root + 12)] @=> int notes[];
			return notes;
		}
		// Dorian
		if ( modeInput == 2 )
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


	
	
	

// ==============================================================================
// Test code

/*
500::ms => dur beat;
MelodyGenerator m;

m.generateMelody(60,2);
beat/m.generateDuration(); => now;

// se ponen es las distancias a la nota raiz, no las notas directamente, esto para poder modular más fácil
//	playMelody(root, octave, multidimensional array [distancia de root, division del beat]
	
m.playMelody(root, [[0,4],[0,4],[7,2],[4,2],[0,2],[0,8],[0,8],[0,2]]);
*/
//===============================================================================

	//========== TODO

	// - Notas debajo del root?
	// - sumatoria del compas
	// - cuadratura


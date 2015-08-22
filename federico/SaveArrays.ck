// ===================================================
// PUBLIC CLASS: FileIO
// File        : FileIO.ck
// Author      : son0p
// Init Date   : 2014-Dec-28
// Dependencies: 
// License     :
// Git repo    : https://github.com/son0p/algo-ritmos
// ===================================================
// This class takes arrays as write/read from a JSON File


public class saveArrays
{ 
	FileIO file;
	private void saveFavorite(int k[])
	{


		file.open( me.dir() + "arrays2.txt", FileIO.WRITE);
		file.size() => file.seek;

		for( 0 => int i; i < k.cap(); i++)
		{
			
			file <= k[i];        
			file <= " ";
			file <= "\n";
			<<< k[i] >>>;
		}
        file.close();
    }
}

// --- Test ----
saveArrays test;
[1,0,1,0] @=> int k[];
test.saveFavorite(k);

// working https://github.com/spencersalazar/chuck/blob/master/src/examples/io/read-int.ck
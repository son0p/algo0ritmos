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


public class FileIO
{ 

	private void saveFavorite(int k[])
    {
        file.open(me.dir() + "arrays.json", FileIO.WRITE);
		file.size() => file.seek;
		//file <= k[];        
        file <= " ";
        
        file <= "\n";
        //file <= k[];
        file.close();
    }
}

// --- Test ----
Bookmark test;
[1,0,1,0] @=> int k[];
test.saveFavorite(k);

// working https://github.com/spencersalazar/chuck/blob/master/src/examples/io/read-int.ck
//"foo.json" => string filename;
"bar.txt" => string fileWrite;
FileIO fio;

// open a file
//fio.open(filename, FileIO.READ);
fio.open(fileWrite, FileIO.WRITE);

// ensure it's ok
// if(!fio.good()) {
//     cherr <= "can't open file: " <= filename <= " for reading..." <= IO.newline();
//     me.exit();
// }

if(!fio.good()) {
    cherr <= "can't open file: " <= fileWrite <= " for writing..." <= IO.newline();
    me.exit();
}
fio.size() => fio.seek; //busca el final del archivo 


// ---- test Read

// //fio.readLine() => string velocity;

// //fio.readLine() => string direction;

// <<< "vel:"+ velocity >>>;
// <<< "dir:"+ direction >>>;

// --- test Write
[10,20,30,40] @=> int velocity[];
20 => int direction;
"\n" => string s;
for(0 => int i; i < velocity.cap(); i++)
   fio <~ velocity[i];
fio.write( s);
fio.write( direction);
fio.close();





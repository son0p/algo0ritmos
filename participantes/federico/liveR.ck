Library lib;

120::ms => dur beat;
64 => int cicleSize;
0 => int counter;
1000.0 => float root; // frecuency center
// frecuencias armonicas
//[root/16,root/8, root/2, root/4, root, root*4, root*2, root*1.189207115, root*1.3348398542, root*1.4983070769, root*1.7817974363, root*1.6817928305] @=> float ref[];
float ref[400];


// [2,1,4,1,4] @=> int aeolianPent[];
// scaleGenerator(65.406391, aeolianPent);

// how many semintores between two freqs
// fun float semitonesFinder(float freqFrom, float freqTo)
//   {
//     log(freqFrom/freqTo)/log(1.05946309436)float howManySemiTones;
//   }

// fun void semitonesGen(float freqFrom, float freqTo)
// {
//   for( 0 => int i;  freqFrom < freqTo; i++)
//   {
//     freqFrom * 1.05946309436 => semitones[i] => freqFrom;
//   }
//   //return semitones;
// }
fun float[] semitonesGen(float freqFrom, float freqTo)
{
  float semitones[300]; // TODO: log(f1/f2)/log(sqr(2;12))
  for( 0 => int i;  i < 299; i++)
  {
    freqFrom * 1.05946309436 => semitones[i] => freqFrom;
  }
  return semitones;

}
semitonesGen(100, 10000) @=> float notes[];

// ERROR : array out of bounds
fun float[] scaleGenerator(float notes[], int scaleJumps[])
{
  float scale[400]; //TODO: fix
  for(0 => int i; i < notes.cap()-1; i++ )
  {
    for (0 => int j; j < scaleJumps.cap()-1; j++)
    {
      notes[i]+scaleJumps[j] => scale[i];
    }
  }
  return scale;
}
[2,1,2,2,2,1] @=> int lydian[];
scaleGenerator(notes,lydian ) @=> ref;



fun void play( int seq[], ADSR instrument )
{
  while(true)
  {
    for( 0 => int i; i < seq.cap(); i++)
    {
      if( seq[i] == 1 && instrument == lib.bd )
      {
        lib.playDrums( instrument, lib.bdImpulse );
      }
      if( seq[i] == 1  )
      {
        lib.playDrums( instrument );
        lib.run(beat);
      }
      else
      {
        lib.run(beat);
      }
    }
  }
}



fun void playBass( string name)
{
  FileIO fio;
  // open a file
  me.dir()+ name;
  fio.open(name, FileIO.READ);
  // ensure it's ok
  if(!fio.good()) {
    cherr <= "can't open file: " <= name <= " for reading..." <= IO.newline();
    me.exit();
  }
  while( fio.more() )
  {
    beat/ms * 16 => float fBeat; 
    now/ms % fBeat => float x;
    Std.atoi(fio.readLine())+.0 => float freq;
    lib.magneticGrid(ref,freq) => lib.sawWave.freq;
    lib.run(beat);
  }
  fio.close();
}

fun void playSin(string name)
{
  FileIO fio;
  // open a file
  me.dir()+ name;
  fio.open(name, FileIO.READ);
  // ensure it's ok
  if(!fio.good()) {
    cherr <= "can't open file: " <= name <= " for reading..." <= IO.newline();
    me.exit();
  }
  while( fio.more() )
  {
    beat/ms * 8 => float fBeat; // to sync period of the trig function try 16, 4, 2
    now/ms % fBeat => float x;  // now/ms % (fBeat*100) breaks
    Std.atoi(fio.readLine())+.0=> float param1;
    lib.magneticGrid(ref,param1) => lib.sinWave.freq;
    lib.run(beat);
  }
}

fun void playL3(string name)
{
  FileIO fio;
  // open a file
  me.dir()+ name;
  fio.open(name, FileIO.READ);
  // ensure it's ok
  if(!fio.good()) {
    cherr <= "can't open file: " <= name <= " for reading..." <= IO.newline();
    me.exit();
  }
  while( fio.more() )
  {
    beat/ms * 8 => float fBeat; // to sync period of the trig function try 16, 4, 2
    now/ms % fBeat => float x;  // now/ms % (fBeat*100) breaks
    Std.atoi(fio.readLine())+.0=> float param1;
    lib.magneticGrid(ref,param1) => lib.sin1.freq;
    lib.run(beat);
  }
}

//==================== test =====================

//======= end test ===========

// ======== mixer ===========
lib.sin.gain     (0.05);
lib.sin.set      ( 0::ms, 200::ms, 0.0, 10::ms);
lib.sin1.gain    (0.5);
//lib.rev          (lib.sin);
lib.revNR.mix    (0.05);
lib.sd.gain      (0.29);
lib.hh.gain      (0.4);

lib.sawWave.gain (0.08);
lib.bass.set     ( 0::ms, 100::ms, .08, 10::ms);
lib.rev          (lib.bass);

// ========= tracks =================


fun void climate( int p[][] )
{
//spork~ lib.predation(lib.bd, lib.bass, 500::ms);
//spork~ lib.predation(lib.sqr, lib.sin, 50::ms);
  spork~ play(lib.euclideangenerator(p[0][0],p[0][1]), lib.bd);         // bd
  spork~ play(lib.euclideangenerator(p[1][0],p[1][1]), lib.sd);        // sn
  spork~ play(lib.euclideangenerator(p[2][0],p[2][1]), lib.hh);         // hh
  spork~ play(lib.euclideangenerator(p[3][0],p[3][1]), lib.bass);      // bass
  spork~ playBass("bass.txt");
  spork~ play(lib.euclideangenerator(p[4][0],p[4][1]), lib.sin);
  spork~ playSin("line2.txt");
  spork~ play(lib.euclideangenerator(p[5][0],p[5][1]), lib.melody1);
  spork~ playL3("line3.txt");
//spork~ play(lib.euclideangenerator(4,12), lib.sin);       // sine
}

// // ------- climate -----------
// //climate([[1,16],[7,16],[0,4],[0,16],[8,16], [1,12]]); // intro
climate([[4,16],[2,16],[3,4],[7,16],[6,16], [64,64]]); //beat
// //climate([[1,16],[0,16],[3,4],[2,12],[4,8], [13,24]]); // buildUp
// //climate([[7,16],[5,16],[7,7],[6,16],[1,12],[7,16]]);
// climate([[0,16],[1,16],[1,3],[1,16],[1,16], [7,12]]); //outro


// === transformations ====
spork~ lib.predation(lib.bd, lib.bass, 1000::ms);

// === live, die, and reborn ===

beat*cicleSize => now;
Machine.add(me.dir()+"/liveR");



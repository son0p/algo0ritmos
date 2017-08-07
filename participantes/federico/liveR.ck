Library lib;

120::ms => dur beat;
64 => int cicleSize;
0 => int counter;
1000.0 => float root; // frecuency center

//  // --------  generación de escalas
//[root/16,root/8, root/2, root/4, root, root*4, root*2, root*1.189207115, root*1.3348398542, root*1.4983070769, root*1.7817974363, root*1.6817928305] @=> float ref[];
float scale1[400];
float scale2[400];
float scale3[400];
// [2,1,4,1,4] @=> int aeolianPent[];
// scaleGenerator(65.406391, aeolianPent);

lib.semitonesGen(55,110 ) @=> float notes1[]; 
lib.semitonesGen(220, 2640/2) @=> float notes2[];
lib.semitonesGen(440,4400 ) @=> float notes3[];

[3,2,2,3,2] @=> int minorPenta[];
lib.scaleGenerator(notes1,minorPenta ) @=> scale1;
lib.scaleGenerator(notes2,minorPenta ) @=> scale2;
lib.scaleGenerator(notes3,minorPenta ) @=> scale3;

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
fun void playBass( string name, float scale[] )
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
    lib.magneticGrid(scale,freq) => lib.sqr0.freq;
    lib.run(beat);
  }
  fio.close();
}

fun void playL2(string name, float scale[])
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
    lib.magneticGrid(scale,param1) => lib.sin0.freq;
    lib.run(beat);
  }
}

fun void playL3(string name, float scale[])
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
    now/ms => float x;  // now/ms % (fBeat*100) breaks
    Std.atoi(fio.readLine())+.0=> float param1; 
    if( param1 < scale[0] ){ lib.blit0.gain(0); }
    else{
      lib.magneticGrid(scale,param1) => lib.blit0.freq;
      }
    lib.run(beat);
  }
}

//==================== test =====================

//======= end test ===========

// ======== mixer ===========
lib.sd.gain      (0.20);
lib.hh.gain       (0.4);
lib.sqr0.gain    (0.02);
//lib.sqr0env.set     ( 0::ms, 10::ms, .0, 1000::ms);
lib.sin0.gain    (0.03);
lib.sin0env.set  ( 0::ms, 200::ms, 0.0, 10::ms);
lib.blit0.gain   (0.05);
lib.blit0rev.mix  (0.1);
//lib.rev          (lib.sqr0); // ERROR: se queda sonando


// ========= tracks =================


fun void climate( int p[][] )
{
//spork~ lib.predation(lib.bd, lib.bass, 500::ms);
//spork~ lib.predation(lib.sqr, lib.sin, 50::ms);
  spork~ play(lib.euclideangenerator(p[0][0],p[0][1]), lib.bd);         // bd
  spork~ play(lib.euclideangenerator(p[1][0],p[1][1]), lib.sd);        // sn
  spork~ play(lib.euclideangenerator(p[2][0],p[2][1]), lib.hh);         // hh
  spork~ play(lib.euclideangenerator(p[3][0],p[3][1]), lib.sqr0env);      // bass
  spork~ playBass("bass.txt", scale1);
  spork~ play(lib.euclideangenerator(p[4][0],p[4][1]), lib.sin0env);
  spork~ playL2("line2.txt", scale2);
  spork~ play(lib.euclideangenerator(p[5][0],p[5][1]), lib.blit0env);
  spork~ playL3("line3.txt", scale3);
//spork~ play(lib.euclideangenerator(4,12), lib.sin);       // sine
}

// // ------- climate -----------
// //climate([[1,16],[7,16],[0,4],[0,16],[8,16], [1,12]]); // intro
climate([[4,16],[9,16],[3,4],[6,16],[6,24], [7,12]]); //beat
// //climate([[1,16],[0,16],[3,4],[2,12],[4,8], [13,24]]); // buildUp
// //climate([[7,16],[5,16],[7,7],[6,16],[1,12],[7,16]]);
// climate([[0,16],[1,16],[1,3],[1,16],[1,16], [7,12]]); //outro


// === transformations ====
//spork~ lib.predation(lib.bd, lib.sqr0env, 1000::ms);

// === live, die, and reborn ===

beat*cicleSize => now;
Machine.add(me.dir()+"/liveR");



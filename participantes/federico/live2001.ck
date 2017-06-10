Library lib;
100::ms => dur beat;
1000.0 => float root; // frecuency center
// frecuencias armonicas
[root, root*4, root*2, root*1.189207115, root*1.3348398542, root*1.4983070769, root*1.7817974363, root*1.6817928305] @=> float ref[];

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


fun void playSin()
{
  while(true)
  {
    now/ms + root => float x;
    root + Math.sin(x)+Math.cos(x*4) * 1000=> float freq;
    lib.magneticGrid(ref,freq)/4 => lib.sinWave.freq;
    lib.run(beat);
  }
}

fun void playBass()
{
  while(true)
  {
    now/ms  => float x;
    root + Math.sin(x/8)+Math.sin(x*80)+Math.cos(x*4000) * 200 => float freq;
    (lib.magneticGrid(ref,freq))/16 => lib.sawWave.freq;
    //chout <= lib.sawWave.freq();
    lib.run(beat);
  }
}

//==================== test =====================

"myFunc.txt" => string myFunc ;
FileIO fio;
0 => int i;
fun void readFunc(string name)
{
  while(true)
  {
    // open a file
    fio.open(name, FileIO.READ);
    // ensure it's ok
    if(!fio.good()) {
      cherr <= "can't open file: " <= name <= " for reading..." <= IO.newline();
      me.exit();
    }
    for( 0 => int i; i < 1; i++)
    {
      fio.readLine() => string myTrigo;
      <<< "read:"+ myTrigo >>>;
    }
    500::ms => now;
  }
}
spork~ readFunc(myFunc);
//======= end test ===========

// ======== mixer ===========
lib.sin.gain     (0.05);
lib.sin.set      ( 0::ms, 200::ms, 0.0, 10::ms);
lib.rev          (lib.sin);
lib.revNR.mix    (0.05);

lib.sawWave.gain (0.02);
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
  spork~ playBass();
  spork~ play(lib.euclideangenerator(p[4][0],p[4][1]), lib.sin);
//spork~ play(lib.euclideangenerator(4,12), lib.sin);       // sine
    spork~ playSin();
}

// ------- climate -----------
climate([[4,16],[1,15],[3,4],[3,12],[2,16]]); // drop


// === transformations ====
spork~ lib.predation(lib.bd, lib.bass, 500::ms);

// === live, die, and reborn ===
beat*16 => now;
Machine.add(me.dir()+"/live2001");

Library lib;
120::ms => dur beat;
32 => int cicleSize;
0 => int counter;
1000.0 => float root; // frecuency center
// frecuencias armonicas
[root, root*4, root*2, root*1.189207115, root*1.3348398542, root*1.4983070769, root*1.7817974363, root*1.6817928305] @=> float ref[];

"myFunc.txt" => string myFunc ; // test

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
    beat/ms * 16 => float fBeat; // to sync period of the trig function try 16, 4, 2
    now/ms % fBeat => float x;  // now/ms % (fBeat*100) breaks
    root + Math.sin(x*2)*1000=> float param1;
    lib.magneticGrid(ref,param1)/4 => lib.sinWave.freq;
    root + (Math.sin(x/2)*100)  => float param2;
    lib.magneticGrid(ref,param2)/4 => lib.sin1.freq;
    //param2 + root => lib.sin1.freq;
    lib.run(beat);
  }
}

fun void playBass()
{
  while(true)
  {
    beat/ms * 16 => float fBeat; 
    now/ms % fBeat => float x;
    root + Math.tan(x/8) * 100 => float freq;
    //root + myFunc() => float freq;
    (lib.magneticGrid(ref,freq))/16 => lib.sawWave.freq;
    //chout <= lib.sawWave.freq();
    lib.run(beat);
  }
}

//==================== test =====================


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
      //<<< "read:"+ myTrigo >>>;
    }
    500::ms => now;
  }
}
spork~ readFunc(myFunc);

fun int quarterCounter()
{
  while(true)
  {
    beat  => now;
    counter + 1 => counter;
  }
}

fun void baseClimate()
{
  
}
fun void variClimate()
{
   
}

fun void conductor()
{
    while(true)
    {
        beat/ms * 16 => float fBeat; 
        now/ms % fBeat  => float x;
        if (x > 0.9){ climate([[1,7],[6,16],[3,4],[1,12],[4,12]]); }
        else                            { climate([[4,16],[4,12],[3,4],[6,16],[ 7,16]]); }
        <<< x >>>;
        beat => now;
    }
}

//spork~ conductor();
//======= end test ===========

// ======== mixer ===========
lib.sin.gain     (0.05);
lib.sin.set      ( 0::ms, 200::ms, 0.0, 10::ms);
lib.sin1.gain    (0.2);
//lib.rev          (lib.sin);
lib.revNR.mix    (0.05);
lib.sd.gain      (0.19);
lib.hh.gain      (0.4);

lib.sawWave.gain (0.03);
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
  spork~ playSin();
  spork~ play(lib.euclideangenerator(p[4][0],p[4][1]), lib.melody1);
//spork~ play(lib.euclideangenerator(4,12), lib.sin);       // sine
}

// ------- climate -----------
climate([[4,16],[12,16],[3,4],[6,16],[7,16]]); // drop
//climate([[4,16],[0,16],[3,4],[4,12],[3,8]]); // buildUp

spork~ quarterCounter();






// === transformations ====
spork~ lib.predation(lib.bd, lib.bass, 1000::ms);

// === live, die, and reborn ===
beat*cicleSize => now;
Machine.add(me.dir()+"/live2001");

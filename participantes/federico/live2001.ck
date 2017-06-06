Library lib;
150::ms => dur beat;
36 => int root;

// frecuency center
Std.mtof(root*2) => float rootFreq;
// frecuencias armonicas
[rootFreq, rootFreq*4, rootFreq*2, rootFreq*1.189207115, rootFreq*1.3348398542, rootFreq*1.4983070769, rootFreq*1.7817974363, rootFreq*1.6817928305] @=> float ref[];

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
  lib.sin.gain     (0.05);
  lib.revNR.mix    (0.2);
  lib.sin.set      ( 0::ms, 200::ms, 0.0, 5::ms);
  lib.rev          (lib.sin);
  while(true){
    500+(Math.sin(now/ms*1.8))+Math.cos(now/ms*4)*100=> float freq;
    <<< "freq:"+freq+" "+"now"+now/ms>>>;
    lib.magneticGrid(ref,freq) => lib.sinWave.freq;
    //freq => lib.sinWave.freq;
    lib.run(beat);
  }
}

fun void playBass()
{
    lib.sawWave.gain (0.02);
    lib.bass.set      ( 0::ms, 100::ms, .0, 100::ms);
    lib.rev          (lib.bass);
    while(true)
    {
        Std.mtof(root + 12 + Math.sin( 100*(now/ms))*1.60*pi*8) => float freq;
        (lib.magneticGrid(ref,freq))/8 => lib.sawWave.freq;
        lib.run(beat);
    }
}

//spork~ lib.predation(lib.bd, lib.bass, 500::ms);
//spork~ lib.predation(lib.sqr, lib.sin, 50::ms);

 spork~ play(lib.euclideangenerator(4,16), lib.bd);         // bd
spork~ play(lib.euclideangenerator(5,15), lib.sd);        // sn
spork~ play(lib.euclideangenerator(3,4), lib.hh);         // hh
spork~ play(lib.euclideangenerator(5,12), lib.bass);      // bass
spork~ playBass();
spork~ play(lib.euclideangenerator(7,12), lib.sin);
//spork~ play(lib.euclideangenerator(4,12), lib.sin);       // sine
spork~ playSin();

beat*16 => now;

Machine.add(me.dir()+"/live2001");

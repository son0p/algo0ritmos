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

fun void playBees()
{
  lib.bees(6);
  6 => int C; //number of bees
  // bees
  while(true)
  {
    //for ( 0 => int ii ; ii < C ; ++ii ) { lib.bees.e[ii].keyOn(); }
    lib.run(beat);
    //for ( 0 => int ii ; ii < C ; ++ii ) { lib.bees.e[ii].keyOff(); }
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

fun void playSin()
{
  lib.revNR.mix    (0.2);
  lib.sin.set      ( 0::ms, 200::ms, 0.0, 5::ms);
  lib.rev          (lib.sin);
  while(true){
    1000+(Math.sin(now/ms*1.3))+Math.cos(now/ms*4)*500=> float freq;
    <<< "freq:"+freq+" "+"now"+now/ms>>>;
    lib.magneticGrid(ref,freq) => lib.sinWave.freq;
    //freq => lib.sinWave.freq;
    lib.run(beat);
  }
}
fun void playSqr()
{
  lib.revNR.mix    (0.1);
  //lib.sqrWave.gain (0.01);
  lib.sqr.set      ( 1::ms, 100::ms, 0.05, 100::ms);
  lib.rev          (lib.sqr);
  //15.00001 => float amplitude;
  while(true)
  {
    Std.mtof(root + 36 + Math.sin( 100*(now/ms))*1.1001*pi) => float freq;
    lib.magneticGrid(ref,freq) => lib.sqrWave.freq;
    lib.run(beat * 2);
    [1,2,4,8] @=> int step[];
    lib.run(beat*(step[Math.random2(0,step.cap()-1)]));
  }
}

fun void filter()
{
  while(true)
    {
      Math.fabs(Math.sin((now/ms)%5000)*1000) => float filterFreq;
      filterFreq => lib.sqrFilter.freq;
      //<<< filterFreq >>>;
      lib.sqrFilter.gain(10.01);
      lib.run(beat);
    }
}

// mixer
0.9 =>   lib.bd.gain;
0.5 =>   lib.sd.gain;
0.3 =>   lib.hh.gain;
0.6 => lib.bass.gain;
0.013 =>lib.sin.gain;
0.005 =>lib.sqr.gain;

spork~ lib.predation(lib.bd, lib.bass, 500::ms);
//spork~ lib.predation(lib.sqr, lib.sin, 50::ms);

//spork~ lib.bassLine(1, 4);
//spork~ test();
// spork~ play(lib.euclideangenerator(8,16), lib.bd);         // bd
//  spork~ play(lib.euclideangenerator(7,15), lib.sd);        // sn
//  spork~ play(lib.euclideangenerator(3,4), lib.hh);         // hh
// spork~ play(lib.euclideangenerator(5,12), lib.bass);      // bass
// spork~ playBass();
spork~ play(lib.euclideangenerator(1,1), lib.sin);       // sine
spork~ playSin();
//spork~ play(lib.euclideangenerator(2,6), lib.sqr);       // sqr
//spork~ playSqr();

//spork~ filter();
//spork~ lib.bees(6);
beat*16 => now;

Machine.add(me.dir()+"/live2001");

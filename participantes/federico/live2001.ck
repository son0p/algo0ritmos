Library lib;
120::ms => dur beat;
36 => int root;

// frecuency center
Std.mtof(root*2) => float rootFreq;
// frecuencias armonicas
[rootFreq, rootFreq*2, rootFreq*1.189207115, rootFreq*1.3348398542, rootFreq*1.4983070769, rootFreq*1.7817974363] @=> float ref[];

int chanceBd[16];
int chanceSd[16];
int chanceHh[16];
int chanceBass[16];
int chanceBassNotes[16];
int chanceMel[16];
int chanceMelNotes[16];

fun void drumsFunction()
{
  while(true)
  {
    // cast
    (Math.sin( 120*(now/ms))*1.70) $ int => int position;
    if( position == 0)
    {
      lib.playDrums(lib.bd, lib.bdImpulse );
      lib.run(beat*2);
    }
    else
    {
      lib.run(beat);
    }
  }
}

fun void drums( int seq[], ADSR instrument )
{
    while(true)
    {
        for( 0 => int i; i < seq.cap(); i++)
        {
          if( seq[i] == 1 )
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
fun void drumsImpulse( int seq[], ADSR instrument )
{
    while(true)
    {
        for( 0 => int i; i < seq.cap(); i++)
        {
            if( seq[i] == 1 )
            {
                lib.playDrums( instrument, lib.bdImpulse );
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
    Std.mtof(root + 12 + Math.tan( 10*(now/ms))*10.20*pi) => float freq;
    (lib.magneticGrid(ref,freq))/8 => lib.sawWave.freq;
    lib.run(beat);
  }
}


fun void playSin()
{
  lib.revNR.mix    (0.2);
  
  lib.sin.set      ( 0::ms, 100::ms, 0.0, 5::ms);
  lib.rev          (lib.sin);

  while(true){
    Std.mtof(root + 48 + Math.cos( 100*(now/ms))*1.1001*pi) => float freq;
    lib.magneticGrid(ref,freq) => lib.sinWave.freq;
    lib.run(beat);
  }
}
fun void playSqr()
{
  lib.revNR.mix    (0.1);
  lib.sqrWave.gain (0.01);
  lib.sqr.set      ( 1::ms, 100::ms, 0.05, 100::ms);
  lib.rev          (lib.sqr);
  15.00001 => float amplitude;
  while(true)
  {
    Std.mtof(root + 36 + Math.tan( 100*(now/ms))*8.1001*pi) => float freq;
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

fun int checkArray( int seq[], int iter )
{
  int value;
  for(int i; i < seq.cap();i++)
  {
    if( seq[i] == iter )
    {
      1 =>  value;
    }
  }
  return value;
}

// perturba el comportamiento de un ADSR según una función matemática
fun void perturbation()
{
  
}

fun void test()
    {
        lib.revNR.mix    (0.1);
        lib.sqrWave.gain (0.01);
        lib.sqr.set      ( 1::ms, 100::ms, 0.05, 100::ms);
        lib.rev          (lib.sqr);
        15.00001 => float amplitude;
        while(true){
            now/ms => float x;
            lib.sqr.keyOn();
             //Std.mtof(root + 36 + (Math.sin((now/ms)*(2*pi/10000)))) => float freq;
             (Math.sin(x*(2*pi/10000)*1))*1000 => float freq;
            freq => lib.sqrWave.freq;
            lib.run(beat/10);
            <<<freq>>>;
            //[1,2,4,8] @=> int step[];
            //lib.run(beat*(step[Math.random2(0,step.cap()-1)]));
            lib.sqr.keyOff();
        }
    }

// mixer
0.9 =>   lib.bd.gain;
0.4 =>   lib.sd.gain;
0.3 =>   lib.hh.gain;
0.6 => lib.bass.gain;
0.5 =>  lib.sin.gain;
0.6 =>  lib.sqr.gain;

spork~ lib.predation(lib.bd, lib.bass, 500::ms);
//spork~ lib.predation(lib.sqr, lib.sin, 50::ms);

//spork~ lib.bassLine(1, 4);
//spork~ test();


spork~ drumsImpulse(lib.euclideangenerator(4,16), lib.bd);
spork~ drums(lib.euclideangenerator(3,4), lib.hh);
spork~ drums(lib.euclideangenerator(7,12), lib.sd); 

//spork~ lib.bees(6);

spork~ drums(lib.euclideangenerator(8,12), lib.bass);
spork~ playBass();
lib.revNR.mix(0.02);

spork~ drums(lib.euclideangenerator(6,21), lib.sin);
spork~ playSin(); 
lib.sinWave.gain (0.03);

spork~ drums(lib.euclideangenerator(5,16), lib.sqr);
spork~ playSqr();
//spork~ filter();
beat*16 => now;

Machine.add(me.dir()+"/live2001");

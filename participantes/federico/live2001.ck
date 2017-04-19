Library lib;
120::ms => dur beat;
36 => int root;
// frecuency center
Std.mtof(root*2) => float rootFreq;
// frecuencias armonicas
[rootFreq, rootFreq*2, rootFreq*1.189207115, rootFreq*1.3348398542
 , rootFreq*1.4983070769, rootFreq*1.7817974363

] @=> float ref[];

int chanceBd[16];
int chanceSd[16];
int chanceHh[16];
int chanceBass[16];
int chanceBassNotes[16];
int chanceMel[16];
int chanceMelNotes[16];


// kick
[0,4,8,12] @=> int onKick[];
for( int i; i < onKick.cap(); i++)
{
  100 => chanceBd[onKick[i]]; 
}

// melody
[2  ,  3,  4,   5,  6,  8, 10, 12, 14] @=> int onMel[];
[100, 90, 100, 70, 50, 50, 50, 50, 50] @=> int onMelChances[];
lib.fillArray( chanceMel, onMel, onMelChances);
// notas
[ 0,  12,  3,  -2, 7 , 0, 3, 24, 48] @=> int melNoteAlterations[];
lib.fillArray( chanceMelNotes, onMel, melNoteAlterations);

lib.floatChance( 50, 0, 1 );

// posiciones en que suena
[  2,  6,  10, 14] @=> int onBass[];
[100, 90, 100, 70] @=> int onBassChances[];
lib.fillArray( chanceBass, onBass, onBassChances);
// notas
[ 0,  12,  0,  -2] @=> int bassNoteAlterations[];
lib.fillArray( chanceBassNotes, onBass, bassNoteAlterations);

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
    lib.revNR.mix    (0.2);
    lib.sawWave.gain (0.03);
    lib.bass.set      ( 0::ms, 100::ms, 0.3, 5::ms);
    lib.rev          (lib.bass);

    while(true){
        lib.bass.keyOn();
        Std.mtof(root + 12 + Math.sin( 100*(now/ms))*10.1001*pi) => float freq;
        (lib.magneticGrid(ref,freq))/8 => lib.sawWave.freq;
        lib.run(beat*2);
        lib.bass.keyOff();
    }
}

fun void playSin()
{
  lib.revNR.mix    (0.2);
  lib.sinWave.gain (0.05);
  lib.sin.set      ( 0::ms, 100::ms, 0.3, 5::ms);
  lib.rev          (lib.sin);

  while(true){
    lib.sin.keyOn();
    Std.mtof(root + 48 + Math.cos( 100*(now/ms))*1.1001*pi) => float freq;
    lib.magneticGrid(ref,freq) => lib.sinWave.freq;
    lib.run(beat*2);
    lib.sin.keyOff();
  }
}
fun void playSqr()
{
  lib.revNR.mix    (0.1);
  lib.sqrWave.gain (0.01);
  lib.sqr.set      ( 1::ms, 100::ms, 0.05, 100::ms);
  lib.rev          (lib.sqr);
  15.00001 => float amplitude;
  while(true){
    lib.sqr.keyOn();
    Std.mtof(root + 36 + Math.cos( 100*(now/ms))*8.1001*pi) => float freq;
    lib.magneticGrid(ref,freq) => lib.sqrWave.freq;
    lib.run(beat * 2);
    [1,2,4,8] @=> int step[];
    lib.run(beat*(step[Math.random2(0,step.cap()-1)]));
    lib.sqr.keyOff();
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

fun void drums()
{
  0 => int i;
  while(true)
  {
    checkArray( onKick, i ) => int kOn;
    if( kOn == 1 )
      {
        lib.playDrums(lib.bd, lib.bdImpulse );
      }
    //lib.playDrums(1, lib.sd );
    lib.run(beat);
    i++;
  }
}

// test
fun void test()
{
  while(true)
  {
    lib.magneticGrid(ref, 4.1) => float ret;
    <<< ret >>>;
    500::ms => now;
  }
}
//spork~ test();

//spork~ lib.bassLine(1, 4);
spork~ drums();
//spork~ lib.bees(6);
spork~ playBass();
//spork~ playSin();
spork~ playSqr();
spork~ filter();
beat*16 => now;

Machine.add(me.dir()+"/live2001");

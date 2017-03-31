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
  0 => int i;
  while(true)
    {
      lib.floatChance( chanceBass[i], 1,0 )   => float bassSwitch;
      chanceBassNotes[Math.random2(0, 15)]    => float bassNote;
      lib.bass.keyOff();
      if( bassSwitch == 1 ){ Std.mtof( bassNote + root ) => lib.saw.freq; lib.bass.keyOn();  }
      lib.run(beat);
      i++;
    }
}

fun void playSin()
{
  lib.revNR.mix    (0.2);
  lib.sinWave.gain (1.0);
  lib.sin.set      ( 0::ms, 100::ms, 0.2, 500::ms);
  lib.sin.keyOn();
  //lib.run          (beat);
  lib.sin.keyOff();
  lib.rev          (lib.sin);
  
  while(true){
    // arco largo
    //Std.mtof(root + 12 + Math.hypot(now/beat, now/beat)*0.0030001*pi) => lib.sinWave.freq;

    // 2 sparks 00001 leve variacion
    Std.mtof(root + 48 + Math.cos( 1000*(now/ms))*0.1001*pi) => float freq;
    // lib.magneticGrid(ref,freq) => lib.sinWave.freq;
    440 => lib.sinWave.freq;
    <<<freq>>>;

    //    Std.mtof(root + 12 + Math.tan(2)*0.09001*pi) => lib.sinWave.freq;

    //chout <= (now/second+";"+lib.sinWave.freq()+"\n");

    //Std.mtof(root + 24 + Math.sqrt(now/beat)*2.09001*pi) => lib.sinWave.freq;
    lib.run(beat*2);
  }
}
fun void playSqr()
{
  lib.revNR.mix    (0.05);
  lib.sqrWave.gain (0.0101);
  lib.sqr.set      ( 1::ms, 100::ms, 0.1, 10::ms);
  lib.rev          (lib.sqr);
  while(true){
    lib.sqr.keyOn();
    // arco largo
    //Std.mtof(root + 12 + Math.hypot(now/beat, now/beat)*0.0030001*pi) => lib.sqrWave.freq;

    // 2 sparks 00001 leve variacion
    //Std.mtof(root + 24 + Math.tan( 100*(now/ms))*3.1001*pi) => lib.sqrWave.freq;

    Std.mtof(root + 36 + Math.sin((now/ms)/(4*beat/ms))*5.0000091*pi) => float freq;
    freq => lib.sqrWave.freq;
    //lib.magneticGrid(ref,freq) => lib.sqrWave.freq;
    if( lib.sqrWave.freq() > 10000.0 ){ lib.sqrWave.gain(0.0);}
    else { lib.sqrWave.gain (0.0101); }
    // filter
    chout <= (now/second+";"+lib.sqrWave.freq()+"\n");

    //Std.mtof(root + 24 + Math.sqrt(now/beat)*2.09001*pi) => lib.sqrWave.freq;
    lib.run(beat/8);
    [1,2,4,8] @=> int step[];
    //lib.run(beat*(step[Math.random2(0,step.cap()-1)]));
    lib.sqr.keyOff();
  }
}

fun void filter()
{
  100000 + Math.sin(1*(now/ms))*0.000002*pi => lib.sqrFilter.freq;
  lib.sqrFilter.gain();
  lib.run(beat/1);
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


 fun void playMelody()
{
  0 => int i;
  while(true)
    {
      0.1 => lib.sin1.gain;
      lib.floatChance( chanceMel[i], 1,0 )   => float melSwitch;
      chanceMelNotes[Math.random2(0, 15)]   => float melNote;
      lib.melody1.keyOff();
      if( melSwitch == 1 ){ Std.mtof( melNote +24 + root ) => lib.sin1.freq; lib.melody1.keyOn();  }
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
spork~ playMelody();
//spork~ playSin();
spork~ playSqr();
spork~ filter();
beat*16 => now;

Machine.add(me.dir()+"/live2001");

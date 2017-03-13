Library lib;
120::ms => dur beat;
36 => int root;

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
  lib.sinWave.gain (0.1);
  lib.sin.set      ( 0::ms, 100::ms, 0.2, 10000::ms);
  lib.sin.keyOn();
  lib.run          (beat);
  lib.sin.keyOff();
  lib.rev          (lib.sin);
  
  while(true){
    // arco largo
    //Std.mtof(root + 12 + Math.hypot(now/beat, now/beat)*0.0030001*pi) => lib.sinWave.freq;
    // 2 sparks 00001 leve variacion
    //Std.mtof(root + 24 + Math.tan(now/beat)*0.0000001*pi) => lib.sinWave.freq;

    Std.mtof(root + 24 + Math.sqrt(now/beat)*0.0500001*pi) => lib.sinWave.freq;

    lib.run(beat/8);
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

//spork~ lib.bassLine(1, 4);
spork~ drums();
spork~ lib.bees(6);
spork~ playBass();
spork~ playMelody();
spork~ playSin();
beat*16 => now;

Machine.add(me.dir()+"/live2001");

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

fun void playBass()
{
  0 => int i;
  while(true)
    {
      lib.floatChance( chanceBass[i], 1,0 )   => float bassSwitch;
      chanceBassNotes[Math.random2(0, 15)]    => float bassNote;
      lib.bass.keyOff();
      if( bassSwitch == 1 ){ Std.mtof( bassNote + root ) => lib.saw.freq; lib.bass.keyOn();  }
      beat  => now;
      i++;
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
    beat => now;
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
      beat  => now;
      
      i++;
    }
}

//spork~ lib.bassLine(1, 4);
spork~ drums();
spork~ lib.bees();
spork~ playBass();
spork~ playMelody();
beat*16 => now;

Machine.add(me.dir()+"/live2001");

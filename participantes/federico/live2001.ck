Library lib;
120::ms => dur beat;
36 => int root;

int chanceBd[16];
int chanceSd[16];
int chanceHh[16];
int chanceBass[16];
int chanceBassNotes[16];

[0,4,8,12] @=> int onKick[];
for( int i; i < onKick.cap(); i++)
{
  100 => chanceBd[onKick[i]]; 
}

[  2,  6,  10, 14] @=> int onBass[];
[100, 90, 100, 70] @=> int onBassChances[];
//for( int i; i < onBass.cap(); i++)
//{
//  onBassChances[i] => chanceBass[onBass[i]];
//}

lib.fillArray( chanceBass, onBass, onBassChances);

fun void drums()
{
 
  //100 => chanceBd[8];
  0 => int i;
  while(true)
  {
    lib.floatChance( chanceBd[i], 1,0 )     => float bdSwitch;
    lib.floatChance( chanceSd[i], 1,0 )     => float sdSwitch;
    lib.floatChance( chanceHh[i], 1,0 )     => float hhSwitch;
    lib.bd.keyOff();
    lib.sd.keyOff();
    lib.hh.keyOff();
    if( bdSwitch == 1 ){ lib.bd.keyOn(); 1.0 => lib.bdImpulse.next;  }
    if( sdSwitch == 1 ){ lib.sd.keyOn(); }
    if( hhSwitch == 1 ){ lib.hh.keyOn(); }
    beat  => now;
    i++;
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
      beat  => now;
      i++;
    }
}


spork~ drums();
spork~ playBass();
 
beat*16 => now;

Machine.add(me.dir()+"/live2001");

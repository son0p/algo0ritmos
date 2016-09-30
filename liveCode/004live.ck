// TODO:
// - el beat esta inestable

220::ms => dur beat;
0 => int count16;

MidiOut mout;
mout.open(0);

// print number of args
<<< "number of arguments:", me.args() >>>;
me.args() => int size;
int notes[me.args()];

// print each
for( int i; i < me.args(); i++ )
  {
    <<< "   ", me.arg(i) >>>;
    Std.atoi(me.arg(i)) @=>  notes[i];
  }

fun void  playMIDI(int channel)
{
    while(true)
    {
        for( int i; i < size; i++)
        {
            //Std.atoi(me.arg(1)) => int note; // TODO: deberia poderse esto?
            notes[i] => int note;
            
            MidiMsg msg;
          if( note == 0 )
            {
              0x90 + channel => msg.data1;
              note => msg.data2;
              0 => msg.data3;
              mout.send(msg);
              beat => now;
            }
          else
            {
              0x90+ channel => msg.data1;
              note => msg.data2;
              127 => msg.data3;
              mout.send(msg);
              beat => now;
              0x90+ channel => msg.data1;
              note => msg.data2;
              0 => msg.data3;
              mout.send(msg);
            }
        }
    }
}

// contadores

0 => int i;
fun void counters()
{
  while(true)
    {
      i + 1 => i;
      beat => now;
      i % 16 => count16;
    }
}

/* spork~counters(); */
/* spork~playMIDI(2, kickT, f1); */
/* spork~playMIDI(2, snareT, f2); */
/* spork~play(hihat, hihatT, f3); */
/* //spork~play(bass, bassT, f4); */
/* spork~playMIDI(0, bassT, f4); */
spork~ playMIDI(0); 


while(true) 10::ms => now;

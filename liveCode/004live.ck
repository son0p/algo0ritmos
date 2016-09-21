// TODO:
// - debe poder leer archivos con diferentes cantidades de líneas
// - quitar batería
120::ms => dur beat;
0 => int count16;

MidiOut mout;
mout.open(0);


// shows getting command line arguments
//    (example run: chuck args:1:2:foo)

// print number of args
<<< "number of arguments:", me.args() >>>;

// print each
for( int i; i < me.args(); i++ )
  {
    <<< "   ", me.arg(i) >>>;
    
  }

//me.arg(0) => string a;
//<<<a>>>;

fun void  playMIDI(int channel)
{
    while(true)
    {
        for( int i; i < 4; i++)
        {
            Std.atoi(me.arg(i)) => int note;
            <<< note>>>;
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
                <<< "play">>>;
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
spork~ playMIDI(1); 


while(true) 10::ms => now;

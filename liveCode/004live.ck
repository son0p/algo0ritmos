// TODO:
// - hacer un condicional con un argumento

220::ms => dur beat;

MidiOut mout;
mout.open(0);

// inicia cosas
me.args() => int size;
int notes[me.args()]; // TODO: el tamaño no debe ser de todos los arg, solo las notas?

// asigna  notas
for( 2 => int i; i < me.args(); i++ )
  {
    Std.atoi(me.arg(i)) @=>  notes[i];
  }

// functiones para mandar MIDI
fun void  playMIDI(int channel)
{
  while(true)
    {
      for( 2 => int i; i < size; i++)
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

if( me.arg(0)== "bass" )
  {
    spork~ playMIDI(0);
  }
if( me.arg(0)== "bDrum" )
  {
    spork~ playMIDI(1);
  }

while(true) 10::ms => now;

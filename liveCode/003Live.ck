// TODO:
// - debe poder leer archivos con diferentes cantidades de líneas
// - quitar batería
120::ms => dur beat;
0 => int count16;

MidiOut mout;
mout.open(0);


// Hacemos un bombo, filtrando un Impuslo.
Impulse kick => TwoPole kp => dac;
5000.0 => kp.freq; 0.5 => kp.radius;
0.3 => kp.gain => float globalKpGain;
SinOsc tone => ADSR toneKick => dac;
toneKick.set(0.001,0.09,0.1,0.1);
0.3 => tone.gain;
51.9 => tone.freq;
// ojo RezonZ

// Hacemos un redoblante, filtrando un Noise.
Noise n => ADSR snare => TwoPole sp => NRev snRev => dac;
800.0 => sp.freq; 0.9 => sp.radius;
snare.set(0.001,0.1,0.01,0.01);
0.01 => sp.gain;
0.0001 => snRev.mix;

// Hacemos un charles, filtrando un Noise.
Noise h => ADSR hihat => TwoPole hsp => NRev hhRev => dac;
10000.0 => hsp.freq; 0.9 => hsp.radius;
0.05 => float hhSustain;
hihat.set(0.001,hhSustain,0.0,0.1);
0.02 => hsp.gain => float globalHspGain;
0.001 => hhRev.mix;

SqrOsc b => ADSR bass => NRev bassRev => dac;
0.05 => b.gain;
0.03 => bassRev.mix;


// Seq
"kick.txt" => string kickT;
"snare.txt" => string snareT;
"hihat.txt" => string hihatT;
"bass.txt" => string bassT;
"lead1.txt" => string lead1T;
FileIO f1;
FileIO f2;
FileIO f3;
FileIO f4;
FileIO f5;


// Suena Drums
fun void  play(ADSR adsr, string instrument, FileIO fio )
{
  while(true)
    {
      // open a file
      fio.open(instrument, FileIO.READ);
      // ensure it's ok
      if(!fio.good()) {
        cherr <= "can't open file: " <= instrument <= " for reading..." <= IO.newline();
        me.exit();
      }
      for( 0 => int i; i < 16; i++)
        {
          Std.atoi(fio.readLine()) => int note;
          if( note == 0 ) adsr.keyOff(); 
          else {adsr.keyOn(); 1.0 => kick.next; Std.mtof(note) => b.freq;}
          beat => now;
        }
    }
}

fun void  playMIDI(int channel, string instrument, FileIO fio )
{
  // tamaño
  0 => int size;
  fio.open(instrument, FileIO.READ);
  while( fio.more() )
    {
      size + 1 => size;
      fio.readLine();
    }
  // play
    while(true)
    {
      // open a file
      fio.open(instrument, FileIO.READ);
      // ensure it's ok
      if(!fio.good()) {
        cherr <= "can't open file: " <= instrument <= " for reading..." <= IO.newline();
        me.exit();
      }
      // Aquí traté de usar directamente while ( fio.more()) pero sacaba una linea extra
      // fue necesario determinar el número de líneas arriba (ugly)
      for( 0 => int i; i < size-1; i++)
        {
          Std.atoi(fio.readLine()) => int note;
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

spork~counters();
spork~playMIDI(2, kickT, f1);
spork~playMIDI(2, snareT, f2);
spork~play(hihat, hihatT, f3);
//spork~play(bass, bassT, f4);
spork~playMIDI(0, bassT, f4);
spork~playMIDI(1, lead1T, f5);


while(true) 10::ms => now;

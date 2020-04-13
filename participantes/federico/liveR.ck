Library lib;
Inmutable inmutable;

120::ms => dur beat;
16 => int cicleSize;
0 => int counter;
1000.0 => float root; // frecuency center


// create our OSC receiver
OscRecv recv;
// use port 6449
6449 => recv.port;
// start listening (launch thread)
recv.listen();

// create an address in the receiver, store in new variable
recv.event( "/audio/1/int, i" ) @=>  OscEvent oi;
recv.event( "/audio/1/float, f" ) @=>  OscEvent of;

int intNotes[16];
inmutable.inmutableArray @=>  intNotes;
float floatNotes[16];

fun  void oscRxFloat()
{
    int i;
    while ( true )
    {
        // wait for event to arrive
        of => now;
        while ( of.nextMsg() != 0 )
        {
            of.getFloat() => floatNotes[i%16];
            i++;
        }
    }
}
fun void oscRxInt()
{
    int j;
    while ( true )
    {
        // wait for event to arrive
        oi => now;
        while ( oi.nextMsg() != 0 )
        {
            oi.getInt() =>  inmutable.inmutableArray[j%16];
            j++;
        }
    }
}

fun void play( int seq[], ADSR instrument )
{
  while(true)
  {
    for( 0 => int i; i < seq.cap(); i++)
    {
      if( seq[i] == 1 && instrument == lib.bd )
      {
        lib.playDrums( instrument, lib.bdImpulse );
      }
      if( seq[i] == 1  )
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
// ######### OSC test ############
//int intNotesLocal[16];

fun void playArray()
{
    while(true)
    {
        <<<"start">>>;
        for(0 => int i; i < 16; i++)
        {
            <<< "oscInt:", intNotes[i]>>>;
        }
        0.2::second => now;
   }
}
// ######## END OSC test ###########
SinOsc sin7 => dac;

fun void simplePlay(){
    while(true){
        for(0 => int i; i < 15; i++){
             intNotes[i] => sin7.freq;  
             lib.run(beat);
        }
    }
}
fun void playBass( string name, float scale[] )
{
  FileIO fio;
  // open a file
  me.dir()+ name;
  fio.open(name, FileIO.READ);
  // ensure it's ok
  if(!fio.good()) {
    cherr <= "can't open file: " <= name <= " for reading..." <= IO.newline();
    me.exit();
  }
  while(true)
  {
    beat/ms * 16 => float fBeat; 
    now/ms % fBeat => float x;
    Std.atoi(fio.readLine())+.0 => float freq;
    lib.magneticGrid(scale,freq) => lib.sqr0.freq;
    lib.run(beat);
  }
  fio.close();
}

fun void playL2(string name, float scale[])
{
  FileIO fio;
  // open a file
  me.dir()+ name;
  fio.open(name, FileIO.READ);
  // ensure it's ok
  if(!fio.good()) {
    cherr <= "can't open file: " <= name <= " for reading..." <= IO.newline();
    me.exit();
  }
  while(true)
  {
    beat/ms * 8 => float fBeat; // to sync period of the trig function try 16, 4, 2
    now/ms % fBeat => float x;  // now/ms % (fBeat*100) breaks
    Std.atoi(fio.readLine())+.0=> float freq;
    if(freq < scale[0])
      {
        0 => lib.sin0.freq;
        lib.run(beat); 
      }
    if(freq >= scale[0])
      {
        lib.magneticGrid(scale,freq) => lib.sin0.freq;
        lib.run(beat);
      }
  }
}

fun void playL3(string name, float scale[])
{
  FileIO fio;
  // open a file
  me.dir()+ name;
  fio.open(name, FileIO.READ);
  // ensure it's ok
  if(!fio.good()) {
    cherr <= "can't open file: " <= name <= " for reading..." <= IO.newline();
    me.exit();
  }
  while(true)
  {
    beat/ms * 8 => float fBeat; // to sync period of the trig function try 16, 4, 2
    now/ms => float x;  // now/ms % (fBeat*100) breaks
    Std.atoi(fio.readLine())+.0=> float param1;
    if(param1 < scale[0])
      {
        0 => lib.blit0.freq;
        lib.run(beat);
      }
    if(param1 >= scale[0])
      {
        lib.magneticGrid(scale,param1) => lib.blit0.freq;
        lib.run(beat);
      }
  }
}

fun void playDrum(string name, ADSR instrument)
{
  FileIO fio;
  // open a file
  me.dir()+ name;
  fio.open(name, FileIO.READ);
  // ensure it's ok
  if(!fio.good()) {
      cherr <= "can't open file: " <= name <= " for reading..." <= IO.newline();
      me.exit();
  }
  while(true)
  {
    Std.atoi(fio.readLine()) => int value; // <<< value >>>;
    if( value == 1 && instrument == lib.bd )
    {
      lib.playDrums( instrument, lib.bdImpulse );
    }
    if( value == 1  )
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

// ======== mixer ===========
lib.sd.gain      (0.20);
lib.hh.gain       (0.4);
lib.sqr0.gain    (0.02);
lib.sqr0env.set     ( 0::ms, 10::ms, .0, 1000::ms);
lib.sin0.gain    (0.03);
lib.sin0env.set  ( 0::ms, 200::ms, 0.0, 10::ms);
lib.blit0.gain   (0.05);
lib.blit0rev.mix  (0.1);
//lib.rev          (lib.sqr0); // ERROR: se queda sonando


// ========= tracks =================


fun void climate( int p[][] )
{
//  spork~ play(lib.euclideangenerator(p[0][0],p[0][1]), lib.bd);         // bd
 // spork~ playDrum("bd.txt",lib.bd);
  // spork~ play(lib.euclideangenerator(p[1][0],p[1][1]), lib.sd);        // sn
 // spork~ playDrum("sd.txt",lib.sd);
  //spork~ play(lib.euclideangenerator(p[2][0],p[2][1]), lib.hh);         // hh
  //spork~ playDrum("hh.txt",lib.hh);
  spork~ play(lib.euclideangenerator(p[3][0],p[2][1]), lib.sqr0env);      // bass
 // spork~ playBass("bass.txt", scale1);
  spork~ play(lib.euclideangenerator(p[4][0],p[4][1]), lib.sin0env);
 // spork~ playL2("line2.txt", scale2);
  spork~ play(lib.euclideangenerator(p[5][0],p[5][1]), lib.blit0env);
 // spork~ playL3("line3.txt", scale3);
//spork~ play(lib.euclideangenerator(4,12), lib.sin);       // sine
}

// // ------- climate -----------
//climate([[1,16],[7,16],[0,4],[0,16],[8,16], [1,12]]); // intro
//climate([[4,16],[9,16],[3,4],[5,16],[3,8], [7,12]]); //beat
//climate([[1,16],[0,16],[3,4],[2,12],[4,8], [13,24]]); // buildUp
// //climate([[7,16],[5,16],[7,7],[6,16],[1,12],[7,16]]);
// climate([[0,16],[1,16],[1,3],[1,16],[1,16], [7,12]]); //outro


// === transformations ====
//spork~ lib.predation(lib.bd, lib.sqr0env, 1000::ms);
fun void runningOSC(){
    spork~ oscRxInt();
    1::week => now;
}

fun void playSounds(){
    while(true){
        //climate([[1,16],[0,16],[3,4],[2,12],[4,8], [13,24]]);
        spork~ playArray();
        beat*cicleSize => now;
        spork~ simplePlay();
        //me.yield();
    }
}

spork~ runningOSC();
spork~ playSounds();
spork~ simplePlay();



//spork~ osc.oscRxInt();
//spork~ osc.playArray();

// === live, die, and reborn ===
while(true){
    beat*cicleSize => now;
    }
//Machine.add(me.dir()+"liveR");



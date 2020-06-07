Library lib;
Inmutable inmutable;

120::ms => dur beat;

// create our OSC receiver
OscRecv recv;
// use port 6449
6449 => recv.port;
// start listening (launch thread)
recv.listen();

// create an address in the receiver, store in new variable
recv.event( "/audio/1/int, i" )      @=> OscEvent oi;
recv.event( "/audio/1/envNotes, i" ) @=> OscEvent oscEnvNotes;
recv.event( "/audio/1/float, f" )    @=> OscEvent of;
recv.event( "/audio/2/bass, i" )     @=> OscEvent oscBass;
recv.event( "/audio/2/envBass, i" )  @=> OscEvent oscEnvBass;
recv.event( "/audio/2/bd, i" )       @=> OscEvent oscBD;
recv.event( "/audio/2/sn, i" )       @=> OscEvent oscSN;
recv.event( "/audio/2/hh, i" )       @=> OscEvent oscHH;

int intNotes[16];
int envNotes[16];
int  intBass[16];
int  envBass[16];
int    intBD[16];
int    intSN[16];
int    intHH[16];
inmutable.inmutableArray    @=> intNotes;
inmutable.inmutableEnvNotes @=> envNotes;
inmutable.inmutableBass     @=> intBass;
inmutable.inmutableEnvBass  @=> envBass;
inmutable.inmutableBD       @=> intBD;
inmutable.inmutableSN       @=> intSN;
inmutable.inmutableHH       @=> intHH;
float floatNotes[16];

fun  void oscRxFloat()
{
    int i;
    while ( true ){
        // wait for event to arrive
        of => now;
        while ( of.nextMsg() != 0 ){
            of.getFloat() => floatNotes[i%16];
            i++;
        }
    }
}
fun void oscRxInt()
{
    int j;
    while ( true ){
        // wait for event to arrive
        oi => now;
        while ( oi.nextMsg() != 0 ){
            oi.getInt() =>  inmutable.inmutableArray[j%16];
            j++;
        }
    }
}
fun void oscRxEnvNotes(){
    int i;
    while ( true ){
        // wait for event to arrive
        oscEnvNotes => now;
        while ( oscEnvNotes.nextMsg() != 0 ){
            oscEnvNotes.getInt() =>  inmutable.inmutableEnvNotes[i%16];
            i++;
        }
    }
}
fun void oscRxBass(){
    int j;
    while ( true ){
        // wait for event to arrive
        oscBass => now;
        while ( oscBass.nextMsg() != 0 ){
            oscBass.getInt() =>  inmutable.inmutableBass[j%16];
            j++;
        }
    }
}
fun void oscRxEnvBass(){
    int i;
    while ( true ){
        // wait for event to arrive
        oscEnvBass => now;
        while ( oscEnvBass.nextMsg() != 0 ){
            oscEnvBass.getInt() =>  inmutable.inmutableEnvBass[i%16];
            i++;
        }
    }
}
fun void oscRxBD(){
    int i;
    while(true){
        oscBD => now;
        while( oscBD.nextMsg() != 0 ){
            oscBD.getInt() => inmutable.inmutableBD[i%16];
            i++;
        }
    }
}
fun void oscRxSN(){
    int i;
    while(true){
        oscSN => now;
        while( oscSN.nextMsg() != 0 ){
            oscSN.getInt() => inmutable.inmutableSN[i%16];
            i++;
        }
    }
}
fun void oscRxHH(){
    int i;
    while(true){
        oscHH => now;
        while( oscHH.nextMsg() != 0 ){
            oscHH.getInt() => inmutable.inmutableHH[i%16];
            i++;
        }
    }
}


//// TEST sound

JCRev rev;
SinOsc sin6 => rev => dac;
SqrOsc sqr =>  dac;
0.01 => rev.mix;
0.0 => sqr.gain;
0.0=> sin6.gain;

fun void simplePlay(){
    while(true){
        for(0 => int i; i < 16; i++){
            intNotes[i] => sin6.freq;
            lib.run(beat);
        }
    }
}
fun void bassPlay(){
    while(true){
        for(0 => int i; i < 16; i++){
            intBass[i] => sqr.freq;
            lib.run(beat);
        }
    }
}

fun void playDrum(ADSR instrument, int seq[]){
  while(true){
      for(0 => int i; i < 16; i++){
          seq[i] => int value;
          if( value != 0 && instrument == lib.bd ){
          lib.playDrums(instrument, lib.bdImpulse);
          }
          if(value != 0){
              lib.playDrums(instrument);
              lib.run(beat);
          }
          else
          {
              lib.run(beat);
          }
      }
  }
}

fun void playFreq(Osc inst, int seq[] ){
    while(true){
        for(0 => int i; i < 16; i++){
            seq[i] => int value;
            if(value > 20){
                value => inst.freq;
                lib.run(beat);
            }
            else{
                lib.run(beat);
            }
        }
    }
}

lib.sd.gain      (0.70);
lib.hh.gain       (0.5);
lib.sqr0.gain    (0.05);
lib.sin0.gain     (0.3);
lib.blit0.gain   (0.05);
lib.tri0.gain    (0.20);

lib.sqr0env.set     ( 0::ms, 100::ms, .0, 1000::ms);
lib.sin0env.set     ( 0::ms, 80::ms, 0.0, 10::ms);
lib.blit0env.set    ( 0::ms, 60::ms, 0.0, 10::ms);
lib.tri0env.set     ( 0::ms, 80::ms, 0.0, 10::ms);
/// end TEST sound
fun void runningOSC(){
    spork~ oscRxInt();
    spork~ oscRxEnvNotes();
    spork~ oscRxBass();
    spork~ oscRxEnvBass();
    spork~ oscRxBD();
    spork~ oscRxSN();
    spork~ oscRxHH();
    1::week => now;
}

spork~ runningOSC();
//spork~ simplePlay();  // test
//spork~ bassPlay();   // test
spork~ playDrum(lib.sin0env, envNotes);
spork~ playFreq(lib.sin0, intNotes);
spork~ playDrum(lib.sqr0env, envBass );
spork~ playFreq(lib.sqr0, intBass);
spork~ playDrum(lib.bd, intBD);
spork~ playDrum(lib.sd, intSN);
spork~ playDrum(lib.hh, intHH);

while(true){
    1000*beat => now;
}




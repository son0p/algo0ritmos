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
recv.event( "/audio/1/int, i" )   @=>    OscEvent oi;
recv.event( "/audio/1/float, f" ) @=>    OscEvent of;
recv.event( "/audio/2/bass, i" )  @=>    OscEvent oscBass;

int intNotes[16];
int intBass[16];
inmutable.inmutableArray @=> intNotes;
inmutable.inmutableBass  @=> intBass;
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
fun void oscRxBass()
{
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
//// TEST sound

JCRev rev;
SinOsc sin6 => rev => dac;
SqrOsc sqr =>  dac;
0.01 => rev.mix;
0.3 => sqr.gain;
0.4 => sin6.gain;

fun void simplePlay(){
    while(true){
        for(0 => int i; i < 15; i++){
            intNotes[i] => sin6.freq;
            lib.run(beat);
        }
    }
}
fun void bassPlay(){
    while(true){
        for(0 => int i; i < 15; i++){
            intBass[i] => sqr.freq;
            lib.run(beat);
        }
    }
}
/// end TEST sound
fun void runningOSC(){
    spork~ oscRxInt();
    spork~ oscRxBass();
    1::week => now;
}



spork~ runningOSC();
spork~ simplePlay();
spork~ bassPlay();

while(true){
    beat => now;
}




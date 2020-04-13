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
recv.event( "/audio/1/int, i" ) @=>  OscEvent oi;
recv.event( "/audio/1/float, f" ) @=>  OscEvent of;

int intNotes[16];
inmutable.inmutableArray @=> intNotes;
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
//// TEST sound
SinOsc sin7 => dac;

fun void simplePlay(){
    while(true){
        for(0 => int i; i < 15; i++){
            intNotes[i] => sin7.freq;  
            lib.run(beat);
        }
    }
}
/// end TEST sound
fun void runningOSC(){
    spork~ oscRxInt();
    1::week => now;
}

spork~ runningOSC();
spork~ simplePlay();

while(true){
    beat => now;
}




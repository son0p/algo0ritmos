// first run initialize.ck
//

Library lib;
Global glo;
OSC_Read osc;
OscIn oin;
OscMsg msg;

// osc data to array
 fun void oscRxFloat(){
        while(true){
            // wait for event to arrive
            oin => now;
            while (oin.recv(msg)){
                for(0 => int i; i < 16; i++){
                    msg.getFloat(i) => Global.bassFromOsc[i];
                }
            }
        }
    }

// play some instrument
fun void playBassFromOsc()
{
    while(true)
    {
        Global.bassFromOsc[Global.mod16] => float bassNote;
        lib.bass.keyOff();
        if( bassNote != -1 ){ Std.mtof(bassNote) => lib.fat.freq; lib.bass.keyOn();  }
        Global.beat => now;
        <<< bassNote >>>;
       }
}

// tickers
fun void rollCounter(){
        while(true){
        Global.counter  +  1 @=> Global.counter;
        Global.counter %   4 @=> Global.mod4;
        Global.counter %  16 @=> Global.mod16;
        Global.counter %  32 @=> Global.mod32;
        Global.counter %  64 @=> Global.mod64;
        Global.counter % 256 @=> Global.mod256;
        Global.beat => now;
       // <<< Global.counter, Global.mod16, Global.mod32, Global.mod64 >>>;
    }
}

//// SPORKS
spork~ playBassFromOsc();
spork~ rollCounter();

// keep sporks alive
Global.beat * 256 => now;
// reload me
Machine.add(me.dir()+"simpleOSCpattern.ck:777");

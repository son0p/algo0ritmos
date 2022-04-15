// first run initialize.ck
// tested with  OSC.lisp

Library lib;
Global glo;
OSC_Read osc;
OscIn oin;
OscMsg msg;
6450 => oin.port;
oin.addAddress( "/audio/2/lead, ffffffffffffffff" );
oin.addAddress( "/audio/2/mid,  ffffffffffffffff" );
oin.addAddress( "/audio/2/bass, ffffffffffffffff" );
oin.addAddress( "/audio/2/bd,   iiiiiiiiiiiiiiii" );
oin.addAddress( "/audio/2/sd,   iiiiiiiiiiiiiiii" );
oin.addAddress( "/audio/2/hh,   iiiiiiiiiiiiiiii" );

// osc data to array --------------------
 fun void oscRxFloat()
 {

     while(true)
     {
        oin => now; // wait for event to arrive
        while (oin.recv(msg))
        {
            msg.address => string addr;
            if (addr == "/audio/2/lead" )
            {
                for(0 => int i; i < 16; i++){ msg.getFloat(i) => Global.inmutableLEAD[i]; }
            }
            else if (addr == "/audio/2/mid" )
            {
                for(0 => int i; i < 16; i++){ msg.getFloat(i) => Global.inmutableMID[i]; }
            }
            else if (addr == "/audio/2/bass" )
            {
                for(0 => int i; i < 16; i++){ msg.getFloat(i) => Global.inmutableBASS[i]; }
            }
            else if (addr == "/audio/2/bd" )
            {
                for(0 => int i; i < 16; i++){ msg.getInt(i)   => Global.inmutableBD[i]; }
            }
            else if (addr == "/audio/2/sd" )
            {
                for(0 => int i; i < 16; i++){ msg.getInt(i)   => Global.inmutableSD[i]; }
            }
            else if (addr == "/audio/2/hh" )
            {
                for(0 => int i; i < 16; i++){ msg.getInt(i)   => Global.inmutableHH[i]; }
            }

        }
     }
 }

// play some instrument --------------------
fun void playBassFromOsc()
{
    while(true)
    {
        Global.inmutableBASS[Global.mod16] => float bassNote;
        lib.bass.keyOff();
        if( bassNote > 20 ){ Std.mtof(bassNote) => lib.fat.freq; lib.bass.keyOn();  }
        Global.beat => now;
    }
}

// tickers --------------------
fun void rollCounter()
{
    while(true)
    {
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

//// SPORKS --------------------
spork~ playBassFromOsc();
spork~ rollCounter();
spork~ oscRxFloat();

// keep sporks alive
Global.beat * 16 => now;
// reload me
Machine.add(me.dir()+"simpleOSCpattern.ck");

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
oin.addAddress( "/audio/2/htom, iiiiiiiiiiiiiiii" );
oin.addAddress( "/audio/2/hh,   iiiiiiiiiiiiiiii" );

// mixer --------------------
0.03 => lib.sqr0.gain;
0.05 => lib.sin0.gain;
0.05 => lib.tri0.gain;
0.2 => lib.htom.gain;
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
            else if (addr == "/audio/2/htom" )
            {
                for(0 => int i; i < 16; i++){ msg.getInt(i)   => Global.inmutableHTOM[i]; }
            }
            else if (addr == "/audio/2/hh" )
            {
                for(0 => int i; i < 16; i++){ msg.getInt(i)   => Global.inmutableHH[i]; }
            }

        }
     }
 }

// instrument classes
kjzTT101 A;
A.output => dac;
A.setBaseFreq(140);

// play some instruments --------------------
fun void player(float notes[], ADSR instrumentEnv, Osc instrument)
{
    while(true)
    {
        notes[Global.mod16] => float noteFreq;
        instrumentEnv.keyOff();
        if( noteFreq > 20 )
        {
            noteFreq => instrument.freq;
            instrumentEnv.keyOn();
        }
        Global.beat => now;
    }
}
fun void drumPlayer(int notes[], ADSR instrumentEnv)
{
    while(true)
    {
        if( notes[Global.mod16] == 1 && instrumentEnv != lib.bd )
        {
            lib.playDrums(instrumentEnv);
            Global.beat => now;
        }
        else if( notes[Global.mod16] == 1 && instrumentEnv == lib.bd )
        {
            lib.playDrums(instrumentEnv, lib.bdImpulse);
            Global.beat => now;
        }
        else
        {
             Global.beat => now;
        }
    }
}

fun void instPlayer(int notes[])
{
    while(true)
    {
        if( notes[Global.mod16] == 1 )
        {
            A.hit(.5 );
            Global.beat => now;
        }
        else
        {
             Global.beat => now;
        }
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
spork~ player    (Global.inmutableLEAD, lib.sin0env, lib.sin0);
spork~ player    (Global.inmutableMID,  lib.tri0env, lib.tri0);
spork~ player    (Global.inmutableBASS, lib.sqr0env, lib.sqr0);
spork~ drumPlayer(Global.inmutableBD,   lib.bd);
spork~ drumPlayer(Global.inmutableSD,   lib.sd);
spork~ instPlayer(Global.inmutableHTOM);
spork~ drumPlayer(Global.inmutableHH,   lib.hh);
spork~ rollCounter();
spork~ oscRxFloat();

// keep sporks alive
Global.beat * 16 => now;
// reload me
Machine.add(me.dir()+"simpleOSCpattern.ck");

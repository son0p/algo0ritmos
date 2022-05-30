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

// instrument classes
kjzTT101 htom;
htom.output => dac;
htom.setBaseFreq(123);

Moogi mo;
mo.output => NRev moRev => dac;
0.1 => mo.gain;
0.55 => mo.filterQ;
0.9 => mo.filterSweepRate;
0.09 => moRev.mix;

Fat fat;

// instantiate a Dinky (not connected yet)
Dinky imp;
//  patch
Gain g => NRev r => Echo e => Echo e2 => dac;
// direct/dry
g => dac;
e => dac;

// set up delay, gain, and mix
1500::ms => e.max => e.delay;
3000::ms => e2.max => e2.delay;
1 => g.gain;
.5 => e.gain;
.25 => e2.gain;
.1 => r.mix;

// connect the Dinky
imp.connect( g );
// set the radius (should never be more than 1)
imp.radius( 0.999 );


// mixer --------------------
0.03 => lib.sqr0.gain;
0.05 => lib.sin0.gain;
0.05 => lib.tri0.gain;
0.6 => lib.bd.gain;
1.0 => lib.sd.gain;
0.6 => lib.hh.gain;

// send OSC to change patterns
// destination host name
"localhost" => string hostname;
// destination port number
6667 => int port;
// sender object
OscOut xmit;

// aim the transmitter at destination
xmit.dest( hostname, port );

fun void oscTxFloat()
{
// infinite time loop
    while( true )
    {
        // start the message...
        xmit.start( "/foo/notes" );

        // add int argument
        Math.random2( 0, 1 ) => xmit.add;
        // add float argument
        Math.random2f( .1, .5 ) => xmit.add;

        // send it
        xmit.send();

        // advance time
        Global.beat * 16 => now;
    }
}


// Receive OSC data and fill array --------------------
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
fun void player(float notes[], ADSR instrumentEnv, Fat instrument)
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
fun void player(float notes[])
{
    // to play dinky
    while(true)
    {
        notes[Global.mod16] => float noteFreq;
        if( noteFreq > 20 )
        {
            notes[Global.mod16] => imp.t;
            Global.beat => now;
            imp.c();
        }
        else
        {
             Global.beat => now;
        }
    }
}
fun void player(int notes[])
{
    while(true)
    {
        if( notes[Global.mod16] == 1 )
        {
            htom.hit(.5 );
            Global.beat => now;
        }
        else
        {
             Global.beat => now;
        }
    }
}
fun void player(float notes[], Moogi instrument)
{
    while(true)
    {
        notes[Global.mod16] => float noteFreq;
        if( noteFreq > 20 )
        {
            notes[Global.mod16] => instrument.note;
            Global.beat => now;
            // midSynth.c();
        }
        else
        {
             Global.beat => now;
        }
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
spork~ player     (Global.inmutableLEAD);
spork~ player     (Global.inmutableMID, mo);
spork~ player     (Global.inmutableBASS, lib.bass, lib.fat);
spork~ drumPlayer (Global.inmutableBD,   lib.bd);
spork~ drumPlayer (Global.inmutableSD,   lib.sd);
spork~ player     (Global.inmutableHTOM);
spork~ drumPlayer (Global.inmutableHH,   lib.hh);
spork~ rollCounter();
spork~ oscRxFloat();
spork~ oscTxFloat();

// keep sporks alive
Global.beat * 16 => now;
// reload me
Machine.add(me.dir()+"simpleOSCpattern.ck");

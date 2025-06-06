// first run initialize.ck
// tested with  OSC.lisp

300::ms => Global.beat;

Library lib;
MIDIsender midi01;
MIDIsender midi02;
Global glo;
OSC_Read osc;
OscIn oin;
OscMsg msg;
6450 => oin.port;
oin.addAddress( "/audio/2/lead,     ffffffffffffffff" );
oin.addAddress( "/audio/2/mid,      ffffffffffffffff" );
oin.addAddress( "/audio/2/bass,     ffffffffffffffff" );
oin.addAddress( "/audio/2/midilead, iiiiiiiiiiiiiiii" );
oin.addAddress( "/audio/2/midimid,  iiiiiiiiiiiiiiii" );
oin.addAddress( "/audio/2/midibass, iiiiiiiiiiiiiiii" );
oin.addAddress( "/audio/2/bd,       iiiiiiiiiiiiiiii" );
oin.addAddress( "/audio/2/sd,       iiiiiiiiiiiiiiii" );
oin.addAddress( "/audio/2/htom,     iiiiiiiiiiiiiiii" );
oin.addAddress( "/audio/2/hh,       iiiiiiiiiiiiiiii" );
oin.addAddress( "/audio/2/gain,       iiiiiiiiiiiiiiii" );

// instrument classes
kjzTT101 htom;
htom.output => dac;
htom.setBaseFreq(100);

Moogi mo;
mo.output => NRev moRev => dac;
0.05 => mo.gain;
0.55 => mo.filterQ;
0.9 => mo.filterSweepRate;
0.09 => moRev.mix;

Stif sk;
sk.output => NRev skRev => dac;
.75 => skRev.gain;
.02 => skRev.mix;
0.1 => sk.gain;

Sit sit;
sit.output => NRev sitRev => dac;
.75 => sitRev.gain;
.15 => sitRev.mix;
0.3 => sit.gain;

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
0.5 => g.gain;
.5 => e.gain;
.25 => e2.gain;
.1 => r.mix;

// connect the Dinky
imp.connect( g );
// set the radius (should never be more than 1)
imp.radius( 0.999 );

// midi port
0 => midi01.open;
//1 => midi02.open;
1 => midi01.set_channel;
//2 => midi02.set_channel;

// Bus intermedio para mezcla final
Gain mix => Dyno comp => dac;
1.0 => mix.gain;

// Enruta los ADSR's al bus `mix`,
lib.sqr0env => mix;
lib.sin0env => mix;
lib.tri0env => mix;
lib.tri0rev => mix;
lib.bd => mix;
lib.sd => mix;
lib.hh => mix;
lib.bass => mix;

// Ajusta ganancias por instrumento (mixer)
0.03 => lib.sqr0.gain;
0.05 => lib.sin0.gain;
0.05 => lib.tri0.gain;
0.05 => lib.tri0rev.mix;
0.6 => lib.bd.gain;
1.0 => lib.sd.gain;
0.25 => lib.hh.gain;
0.15 => lib.fat.gain;

// Configura Dyno (compresor)
0.5 => comp.thresh;    // umbral
5.0 => comp.ratio;     // relación de compresión
10::ms => comp.attackTime;
200::ms => comp.releaseTime;



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
    while( true )
    {
        // en mod64 cambia en 60
        if (Global.mod32 == 0)
        {
            // start the message...
            xmit.start( "/foo/no" );

            // add int argument
            // Math.random2( 0, 4 ) => xmit.add;
            Global.cursor % 4  => xmit.add;
            // add float argument, TODO: ¿para qué?
            Math.random2f( .1, .5 ) => xmit.add;

            // send msg formated like: ("/foo/no" 3 0.48002946)
            xmit.send();

            Global.cursor++;
            // advance time
            Global.beat => now;
        }
        else
        {
            Global.beat  => now;
        }

    }
}

fun void oscTxCounter()
{
    while( true )
    {
        // start the message...
        xmit.start( "/foo/counter" );
        // add int argument
        // Math.random2( 0, 4 ) => xmit.add;
        Global.counter  => xmit.add;
        // send msg formated like: ("/foo/no" 3 0.48002946)
        xmit.send();
        Global.beat => now;
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
             if (addr == "/audio/2/midilead" )
            {
                for(0 => int i; i < 16; i++){ msg.getInt(i) => Global.midiLEAD[i]; }
            }
            else if (addr == "/audio/2/midimid" )
            {
                for(0 => int i; i < 16; i++){ msg.getInt(i) => Global.midiMID[i]; }
            }
            else if (addr == "/audio/2/midibass" )
            {
                for(0 => int i; i < 16; i++){ msg.getInt(i) => Global.midiBASS[i]; }
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
            else if (addr == "/audio/2/gain")
            {
                for(0 => int i; i < 16; i++){ msg.getInt(i) => Global.inmutableGAIN[i]; }
            }

        }
     }
 }

fun void playerGain()
{
    while(true)
    {
        (Global.inmutableGAIN[Global.mod16] $ float)/100 =>  lib.bass.gain;
        Global.beat => now;
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
            Global.beat => now;
        }

        else
        {
             instrumentEnv.keyOff();
             Global.beat => now;
        }
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
            midi01.noteon((Std.ftoi(Std.ftom(noteFreq))), 30);
            Global.beat => now;
            midi01.noteoff(Std.ftoi(Std.ftom(noteFreq)));
        }
        else
        {
             instrumentEnv.keyOff();
             Global.beat => now;
        }


    }
}
fun void midiPlayer(int notes[], int velocity, int channel)
{
    while(true)
    {
        notes[Global.mod16] => int midiNote;
        if( midiNote > 20 )
        {
            midi01.noteon(midiNote, velocity, channel);
            Global.beat => now;
            midi01.noteoff(midiNote, channel);
        }
        else
        {
             Global.beat => now;
        }


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
fun void playerHtom(int notes[])
{
    while(true)
    {
        if( notes[Global.mod16] > 1 )
        {
            htom.hit(.5 );
            Global.beat => now;
            notes[Global.mod16] => htom.setBaseFreq;
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
fun void player(float notes[], Stif instrument)
{
    while(true)
    {
        notes[Global.mod16] => float noteFreq;
        if( noteFreq > 20 )
        {
            notes[Global.mod16] => instrument.note;
            Math.random2f( 0, 1 ) =>  instrument.velocity;
            Global.beat => now;
        }
        else
        {
             Global.beat => now;
        }
    }
}
fun void player(float notes[], Sit instrument)
{
    while(true)
    {
        notes[Global.mod16] => float noteFreq;
        if( noteFreq > 20 )
        {
            notes[Global.mod16] => instrument.note;
            Math.random2f( 0.4, 0.9 ) =>  instrument.velocity;
            midi01.noteon((Std.ftoi(Std.ftom(noteFreq))), 30);
            Global.beat => now;
            midi01.noteoff(Std.ftoi(Std.ftom(noteFreq)));
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
        if( notes[Global.mod16] > 1 && instrumentEnv != lib.bd )
        {
            lib.playDrums(instrumentEnv);
            Global.beat => now;
        }
        else if( notes[Global.mod16] > 1 && instrumentEnv == lib.bd )
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
//spork~ lib.print (Global.inmutableBASS);
//spork~ player     (Global.inmutableLEAD,lib.sin0env, lib.sin0);
//spork~ player     (Global.inmutableLEAD, mo);
spork~ player     (Global.inmutableMID, mo);
//spork~ midiPlayer (Global.inmutableBD, 30, 4);
//spork~ midiPlayer (Global.midiLEAD, 70, 1);
//spork~ midiPlayer (Global.midiMID, 70, 2);
//spork~ midiPlayer (Global.midiBASS, 70, 3);
//spork~ midiPlayer (Global.inmutableBD, 70, 10);
//spork~ midiPlayer (Global.inmutableSD, 70, 11);
//spork~ midiPlayer (Global.inmutableHH, 70, 12);
//spork~ player     (Global.inmutableMID, sk);
//spork~ player     (Global.inmutableMID, sit);
//spork~ player     (Global.inmutableMID, lib.tri0env, lib.tri0 );
spork~ player     (Global.inmutableBASS, lib.bass, lib.fat);
spork~ drumPlayer (Global.inmutableBD,   lib.bd);
spork~ drumPlayer (Global.inmutableSD,   lib.sd);
//spork~ playerHtom (Global.inmutableHTOM);
//spork~ playerGain ();
//spork~ drumPlayer (Global.inmutableHH,   lib.hh);
spork~ rollCounter();
spork~ oscRxFloat();
spork~ oscTxFloat();
spork~ oscTxCounter();

// keep sporks alive
Global.beat * 16 => now;
// reload me
Machine.add(me.dir()+"simpleOSCpattern.ck");

120::ms => dur beat;
16 => int cicleSize;

// create our OSC receiver
OscRecv recv;
// use port 6449
6449 => recv.port;
// start listening (launch thread)
recv.listen();

// create an address in the receiver, store in new variable
recv.event( "/audio/1/foo, i" ) @=> OscEvent oe;
recv.event( "/audio/1/foo, f" ) @=> OscEvent oi;

float loop[16];
int intNotes[15];
float floatNotes[15];
function void oscRx()
{// infinite event loop
    while ( true )
    {
        // TODO cambie oe por oi
        // wait for event to arrive
        //oi => now;
        for(0 => int i; i < 15; i++){
            while ( oi.nextMsg() != 0 )
            {
                oi.getInt() => int foo;
                oi.getFloat() => float see;
                <<< foo>>>; <<< see>>>;
                foo => intNotes[i];
                see => floatNotes[i];
            }
            1::second => now;
        }
    // [20, 25, 30, 55] @=> int notes[];
// int melody[notes.cap()];
// for (0 => int i; i < notes.cap(); i++)
// {
//    math.random2(1, notes.cap())-1 => int notesselector;
//    notes[notesselector] => int pushnote;
//    pushnote =>  melody[i];
//    <<<pushnote>>>;
// }
    // grab the next message from the queue.
    // while ( oi.nextMsg() != 0 )
    // {
    //     // getFloat fetches the expected float (as indicated by "f")
    //     oi.getInt() => int foo;
    //     oi.getFloat() => float see;
    //     // print
    //     //<<< "got (via OSC):", foo >>>;
    //     <<< foo>>>;
    //             <<< see>>>;
    // }
    }
}

fun void playArray()
{
    while(true){
        <<< floatNotes[0], floatNotes[1],  floatNotes[2]>>>;
        1::second => now;
    }
}


~spork oscRx();

beat*cicleSize => now;
Machine.add(me.dir()+"ChuckOSCreciever.ck");

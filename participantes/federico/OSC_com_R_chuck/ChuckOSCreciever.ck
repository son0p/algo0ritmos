120::ms => dur beat;
16 => int cicleSize;

// create our OSC receiver
OscRecv recv;
// use port 6449
6449 => recv.port;
// start listening (launch thread)
recv.listen();

// create an address in the receiver, store in new variable
recv.event( "/audio/1/foo, s" ) @=> OscEvent oe;
recv.event( "/audio/1/foo, f" ) @=> OscEvent oi;

float loop[16];
int intNotes[16];
float floatNotes[16];
0=> int i;
fun void oscRx()
{
    while ( true )
    {
         // wait for event to arrive
        oi => now;
        //for(0 => int i; i < 15; i++){
            while ( oi.nextMsg() != 0 )
            {
                oi.getInt() =>  intNotes[i%16];
                oi.getFloat() => floatNotes[i%16];
                i++;
            }
    }
}

fun void playArray()
{
    while(true)
    {
        <<<"start">>>;
        for(0 => int i; i < 16; i++)
        {
            <<< floatNotes[i]>>>;
        }
        1::second => now;
    }
}

spork~ playArray();
spork~ oscRx();

beat*cicleSize*10 => now;
Machine.add(me.dir()+"ChuckOSCreciever.ck");

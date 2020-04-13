120::ms => dur beat;
16 => int cicleSize;

// create our OSC receiver
OscRecv recv;
// use port 6449
6449 => recv.port;
// start listening (launch thread)
recv.listen();

// create an address in the receiver, store in new variable
recv.event( "/audio/1/bar, i" ) @=> OscEvent oe;
recv.event( "/audio/1/foo, f" ) @=> OscEvent oi;

float loop[16];
int intNotes[16];
float floatNotes[16];
0 => int i;
0 => int j;
fun void oscRxFloat()
{
    while ( true )
    {
         // wait for event to arrive
         oi => now;
        //for(0 => int i; i < 15; i++){
            while ( oi.nextMsg() != 0 )
            {
                oi.getFloat() => floatNotes[i%16];
                i++;
            }
    }

}
fun void oscRxInt()
{
    while ( true )
    {
        // wait for event to arrive
        oe => now;
        //for(0 => int i; i < 15; i++){
        while ( oe.nextMsg() != 0 )
        {
            oe.getInt() =>  intNotes[j%16];
            j++;
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
            <<< intNotes[i]>>>;
        }
        1::second => now;
    }
}

spork~ playArray();
spork~ oscRxFloat();
spork~ oscRxInt();

beat*cicleSize*10 => now;
Machine.add(me.dir()+"ChuckOSCreciever.ck");

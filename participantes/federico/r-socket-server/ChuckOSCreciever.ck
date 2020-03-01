// create our OSC receiver
OscRecv recv;
// use port 6449
6449 => recv.port;
// start listening (launch thread)
recv.listen();

// create an address in the receiver, store in new variable
recv.event( "/audio/1/foo, s" ) @=> OscEvent oe;
recv.event( "/audio/1/foo, f" ) @=> OscEvent oi;

// infinite event loop
while ( true )
{
    // TODO cambie oe por oi
    // wait for event to arrive
    oi => now;

    // grab the next message from the queue.
    while ( oi.nextMsg() != 0 )
    {
        // getFloat fetches the expected float (as indicated by "f")
        oi.getInt() => int foo;
        oi.getFloat() => float see;
        // print
        //<<< "got (via OSC):", foo >>>;
        <<< foo>>>;
                <<< see>>>;
    }
}

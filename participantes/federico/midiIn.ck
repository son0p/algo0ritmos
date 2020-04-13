// number of the device to open (see: chuck --probe)
0 => int device;
// get command line
if( me.args() ) me.arg(0) => Std.atoi => device;

// the midi event
MidiIn min;
// the message for retrieving data
MidiMsg msg;

// open the device
if( !min.open( device ) ) me.exit();

// print out device that was opened
<<< "MIDI device:", min.num(), " -> ", min.name() >>>;


FileIO fout;
// open for write


function void writeToFile(int data1,int data2,int data3)
{
	fout.open( "out.txt", FileIO.WRITE );
	// test
	if( !fout.good() )
	{
		cherr <= "can't open file for writing..." <= IO.newline();
		me.exit();
	}
	
	// write some stuff
	//fout <= 1 <= " " <= 2 <= " " <= "foo" <= IO.newline();
	fout <= data1 <= " " <= data2 <= " " <= data3 <= IO.newline();
	
	// close the thing
	fout.close();

}
	
	

// infinite time-loop
while( true )
{
    // wait on the event 'min'
    min => now;

    // get the message(s)
    while( min.recv(msg) )
    {
        // print out midi message
        <<< msg.data1, msg.data2, msg.data3 >>>;
		writeToFile(msg.data1, msg.data2, msg.data3);
    }
	
}
120 => int tempo;
dur bit;
60.0/(tempo) => float SPB;
SPB::second => bit;

Machine.add(me.dir()+"/Drummer.ck") => int drummerID;

while( true )
{
	Machine.add(me.dir()+"/1001generator.ck") => int fileID;
	16*bit => now;
	Machine.remove( fileID );
}
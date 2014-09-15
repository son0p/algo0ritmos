120 => int tempo;
dur bit;
60.0/(tempo) => float SPB;
SPB::second => bit;

while( true )
{
	Machine.add(me.dir()+"/300densidad.ck") => int fileID;
	8*bit => now;
	Machine.remove( fileID );
}
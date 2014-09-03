120 => int tempo;
dur bit;
60.0/(tempo) => float SPB;
SPB::second => bit;

while( true )
{
	Machine.add(me.dir()+"/live001.ck") => int fileID;
	8*bit => now;
	Machine.remove( fileID );
}
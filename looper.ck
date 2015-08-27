120 => int tempo;
dur bit;
60.0/(tempo) => float SPB;
SPB::second => bit;

while( true )
{
	Machine.add(me.dir()+"/live001t.ck") => int fileID;
	16*bit => now;
	Machine.remove( fileID );
}

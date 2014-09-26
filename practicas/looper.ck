120 => int tempo;
dur bit;
60.0/(tempo) => float SPB;
SPB::second => bit;

Machine.add(me.dir()+"/Drummer.ck");
Machine.add(me.dir()+"/Mode.ck");
Machine.add(me.dir()+"/MelodyGenerator.ck");


while( true )
{
	Machine.add(me.dir()+"/1005live.ck") => int fileID;
	16*bit => now;
	Machine.remove( fileID );
}
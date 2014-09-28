120 => int tempo;
dur bit;
60.0/(tempo) => float SPB;
SPB::second => bit;

while( true )
{
	Machine.add(me.dir()+"/live001t.ck") => int fileID;
	8*bit => now;
	Machine.replace( fileID , "/live001t.ck"); // virtual machine doesn't stop if you fuck it up 
}

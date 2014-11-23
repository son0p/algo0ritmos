120 => int tempo;
dur bit;
60.0/(tempo) => float SPB;
SPB::second => bit;

// Agrega la clase Drummer.ck
Machine.add(me.dir()+"/Drummer.ck");
Machine.add(me.dir()+"/Mode.ck");
Machine.add(me.dir()+"/MelodyGenerator.ck");

Machine.add(me.dir()+"/1005live.ck") => int fileID; //add before while loop

while( true )
{
    // Cambia dentro de las comillas el archivos que quieres que 
    // quede en loop, al salvar se actualiza con cada 16 beats.
	16*bit => now; 
	if(Machine.replace( fileID, "/1005live.ck") == true)
	{
	    Machine.remove( fileID );
	    Machine.add(me.dir()+"/1005live.ck") => int fileID; // and problem solved
	}
}

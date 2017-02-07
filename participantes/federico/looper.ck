BPM.sync(110) => BPM.tempo => dur beat;
Machine.add(me.dir()+"/liveCode.ck") => int fileID;
//BPM.pleaseTempo();
while( true )
{
    BPM.tempo => dur beat;
    // Cambia dentro de las comillas el archivos que quieres que
    // quede en loop, al salvar se actualiza con cada 8 beats.
    beat * 8 => now;
    if(Machine.replace( fileID, me.dir() + "/liveCode.ck") == true)
	{
	    Machine.remove( fileID );
	    Machine.add(me.dir()+"/liveCode.ck") => int fileID; // and problem solved
	}

}

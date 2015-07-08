BPM.sync(110) => BPM.tempo => dur beat;

//BPM.pleaseTempo();
while( true )
{
    BPM.tempo => dur beat;
    // Cambia dentro de las comillas el archivos que quieres que
    // quede en loop, al salvar se actualiza con cada 8 beats.
	Machine.add(me.dir()+"/liveCode.ck") => int fileID;
    beat * 8 => now;
   	Machine.replace( fileID, "liveCode.ck");
	Machine.remove( fileID );
}

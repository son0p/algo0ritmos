//BPM.tempo/ms => float tempo;
//BPM.sync(tempo) => dur beat;
//spork~ BPM.metro(8, beat);
BPM.sync(110) => BPM.tempo => dur beat;
BPM.pleaseTempo();
while( true )
{
    // Cambia dentro de las comillas el archivos que quieres que
    // quede en loop, al salvar se actualiza con cada 8 beats.
	Machine.add(me.dir()+"/liveCode.ck") => int fileID;
    beat * 8 => now;
   	Machine.replace( fileID, "liveCode.ck");
	Machine.remove( fileID );


}

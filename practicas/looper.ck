84 => int tempo;
dur bit;
60.0/(tempo) => float SPB;
SPB::second => bit;

// Agrega la clase Drummer.ck
Machine.add(me.dir()+"/FavoriteBeats.ck") => int favsID;

Machine.add(me.dir()+"/Drummer.ck");
Machine.add(me.dir()+"/Mode.ck");
Machine.add(me.dir()+"/MelodyGenerator.ck");
Machine.add(me.dir()+"/Synth.ck");
Machine.add(me.dir()+"/Player.ck");
Machine.add(me.dir()+"/ProgressionGenerator.ck");

while( true )
{
    // Cambia dentro de las comillas el archivos que quieres que 
    // quede en loop, al salvar se actualiza con cada 16 beats.
	Machine.add(me.dir()+"/1005live.ck") => int fileID;
	8*bit => now;
	Machine.replace( fileID, "1005live.ck");
	Machine.remove( fileID );

}

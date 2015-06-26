// BPM.ck
//

public class BPM
{
    static int root; // Acá vive la nota (midi) raiz global
    static int steps;
    static dur tempo;
    static int roundCounter;

    function static dur sync(float tempo)
	{
        60.0/(tempo) => float SPB; // seconds per beat
        SPB :: second => dur tempo;
        // inicializa la cantidad de steps que tiene
        // el secuenciador pero puede ser sobre
        // escrita desde liveCode.ck por ahora
        16 => steps;

        return tempo;
	}

    0 => static int counter;

    function static void  metro(int loop, dur tempo)
    {
        while (true)
        {
            counter % loop => int metroLoop;
            tempo => dur beat;
            beat => now;
            counter++;
            roundCounter++; // codigo legado para que funcione livecode.ck
           // <<< metroLoop, "loop", loop >>>;   // descomentar esta línea si quiere ver los contadores
        }
    }
}

// // --------- Test code ----------

// BPM bpm;

// bpm.sync(120) => dur tempo;
// // un contador de a 8
// spork~ bpm.metro(8, tempo);
// // un contador de a 3
// spork~ bpm.metro(3, tempo);

// // para mantener vivos los spork
// while(true){200::ms => now;}

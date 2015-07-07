// BPM.ck
//

public class BPM
{
    static int root; // Acá vive la nota (midi) raiz global
    static int steps;
    static int roundCounter;
    static dur tempo;
    static int metro4;
    static int metroLoop;
    static int counter;

    function static dur pleaseTempo()
    {
       // <<< "Tempo:", tempo >>>;
        return tempo;
    }

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

    function static void metro(int loop, dur tempoToMetro)
    {

         while (true)
         {
            counter % loop =>  metroLoop;
            tempoToMetro  => now; // TODO: entender porque hay que multiplicar
            counter++;
            // <<< "contador", metroLoop >>>;
           // <<< metroLoop, "loop", loop >>>;   // descomentar esta línea si quiere ver los contadores
       }
    }

    function static dur beat( float beatDiv)
    {
      tempo * beatDiv => dur beat;
      return beat;
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

// BPM.ck

public class BPM
{
    static int root;
    static int steps;
    static dur tempo;
    static int roundCounter;
    static int metro4;
    static int metro3;


    function static dur sync(float tempo)
	{
	    60.0/(tempo) => float SPB; // seconds per beat
        SPB :: second => dur tempo;
        16 => steps; // inicializa la cantidad de steps que tiene el secuenciador pero puede ser sobre escrita desde liveCode.ck
		return tempo;
	}
    0 => static int counter;

    function static void metro()
    {
        counter % steps =>  metro4 ;
        counter++;
        roundCounter++;
    }


}

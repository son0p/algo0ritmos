public class Tempo
    {
        static dur bpm;
        float bps;
        public dur functionBpm (float tempo, float arraycapacity, int grid)
            {
                grid/tempo => float tempoParcial;
                (tempoParcial*16)/arraycapacity => bps;//4 - agrupa unidades
                //return bps;
                bps:: second => bpm;
               // bpm => now;
                return bpm;
            }
    }
    
    // ---------------- test -----------
    //-----------------test prueba de la funcion--------------
    /*
    Tempo mitempo;
    mitempo.functionbpm(125,16)=> dur bpm;
    <<<bpm>>>;
    */ 
    
    //------------------test2 lectura de un array------------
    /*
    Tempo mitempo;
    [70,0,70,0,69,0,69,0,70,0,0,67,0,67,0,0]@=> int bassexample[];
    0 => int enteroarray;
    mitempo.functionbpm(80,16)=> dur bpm;
    for (0 => int i;i<bassexample.cap(); i++)
    {
            bassexample[i] => enteroarray;
            <<<enteroarray>>>;
            bpm => now;
    }
    */
    
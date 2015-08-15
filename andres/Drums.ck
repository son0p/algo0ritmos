Tempo bpm;


public class Drums
{
    BD bd;
    bd.output => dac;
    [1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0]@=> int kick[];
    public void recorrer ()
    { 
        while (true)
        {
            for (0 => int i; i < kick.cap(); i++)
            {
                <<<kick[i]>>>;
                bd.hit(1.0);
                tempo.beatUnity(bpm)::second => now; 
            }
        }
    }
}

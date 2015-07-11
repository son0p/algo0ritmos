public class Melodia
{
    Fm Melo;
        
    Melo.MoGain(1000);
    TriOsc carrier;
    SinOsc moduladora;
    spork~Melo.fmsin(carrier,moduladora);
        
      fun void NumMel(int b[])
            {
        while (true)
        {
            for(0 => int i; i < b.cap(); i++)
              {
                    if (b[i] == 0)
                        {
                    0 => moduladora.freq;
                    0.125::second => now;
                        }       
                    if (b[i] == 1)
                                    {
                    [54,0,52,0,55,0,52,52,0,54,0,0,54,0,0,52,54,0,52,0,55,0,52,0,0,54,0,0,54,0,0,0] @=> int melodia[];
                  
                    for(0 => int c ; c < melodia.cap();c++)
                            {
                                if (melodia[c] == 0)
                                {
                                    0 => carrier.freq;
                                    0.123::second => now;
                                }
                                else
                                {
    Std.mtof(melodia[c]) => moduladora.freq;
                                    0.123::second => now;
                                }
                            }
                        }
                    }
                }
            }
        }




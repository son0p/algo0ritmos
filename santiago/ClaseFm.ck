// Publicacion de la variable
public class Fm
{
    volumen Volumen;
    int ModularFreq;
    10000 => int ModularGain;
               
    TriOsc carrier;
    SinOsc moduladora;
    
        public int MoFreq(int ModFreq)
    {
        if (ModFreq == ModFreq)
        {
            ModFreq => ModularFreq;
            
            return int ModularFreq;
        }
    }
        public int MoGain(int ModuGain)
    {
        if (ModuGain == ModuGain)
        {
            ModuGain => ModularGain;
            <<<"Modulador",ModularGain>>>;
            return int ModularGain;
        }
    }
       
    public void fmsin(Osc carrier, Osc modulador)
    {
        2 => carrier.sync;
        ModularFreq => modulador.freq;
        modulador => carrier => Gain VolumenGen => dac;
        while(true)
        {
        ModularGain => modulador.gain;
            <<<"Modulador",ModularGain>>>;
        Volumen.VOLGENERAL => VolumenGen.gain;
        //<<<"VolumenGen",VolumenGen.gain()>>>;
            0.01::second =>now;
        }
        
    }

    spork~fmsin(carrier,moduladora);
        
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
    
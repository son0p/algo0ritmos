// Publicacion de la variable
public class Fm
{
    volumen Volumen;
    int ModularFreq;
    int ModularGain;
    
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
            
            return int ModularGain;
        }
    }
       
    public void fmsin(Osc carrier, Osc modulador)
    {
        2 => carrier.sync;
        ModularFreq => modulador.freq;
        ModularGain => modulador.gain;
        modulador => carrier => Gain VolumenGen => dac;
        while(true)
        {
        Volumen.VOLGENERAL => VolumenGen.gain;
        <<<"VolumenGen",VolumenGen.gain()>>>;
            0.01::second =>now;
        }
        
    }
    
}